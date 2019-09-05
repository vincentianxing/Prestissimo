namespace :db do
  desc 'get/set revision of course DB'
  task :courses_revision, [:revision_no] => [:environment] do |t, args|
    if args[:revision_no].blank?
      puts Setting.get_val('courses_revision_number')
    else
      Setting.set('courses_revision_number',args[:revision_no])
    end
  end

  desc 'get/set curent semester'
  task :current_semester, [:semester] => [:environment] do |t, args|
    if args[:semester].blank?
      puts Setting.get_val('current_semester')
    else
      Setting.set('current_semester',args[:semester])
      # this line was added on 9/10 to prevent duplicate semesters
      unless (Setting.get_val('semesters').include? args[:semester])
        Setting.set('semesters',args[:semester]+"|"+Setting.get_val('semesters'))
      end
    end
  end
  desc 'get/set revision of enrollment DB'
  task :enrollment_revision, [:revision_no] => [:environment] do |t, args|
    if args[:revision_no].blank?
      puts Setting.get_val('enrollment_revision_number')
    else
      Setting.set('enrollment_revision_number',args[:revision_no])
    end
  end

  desc 'set courses last updated time'
  task :courses_last_updated, [:datetime] => [:environment] do |t, args|
    if args[:datetime].blank?
      puts Setting.get_val('courses_last_updated')
    else
      Setting.set('courses_last_updated',args[:datetime])
    end
  end

  desc 'match hubcourses and professors to departments'
  task assign_departments: :environment do

    # hubcourses to departments
    Hubcourse.all.each do |hc|
      unless hc.department
        d = Department.find_by_dept(hc.hub_id[0..3])
        unless d
          d = Department.new
          d.dept = hc.hub_id[0..3]
          d.dept_long = hc.courses.first.dept_long
          if d.save
            puts "Department #{d.dept} created"
          end
        end
        d.hubcourses << hc
      end
    end
    Professor.all.each do |p|
      p.courses.each do |c|
        d = c.hubcourse.department
        p.departments << d unless p.departments.include? d
      end
    end
  end

  desc 'update the course database'
  task :update_courses, [:course_file, :enrollment_file] => [:environment] do |t, args|

    # update the courses
    File.open(args[:course_file], "r") do |f|
      # keep track of cancelled courses that were hidden so that their replacements can also be hidden.
      hidden_courses = []
      f.each_line do |course|
        delete = (course[0] == '<')
        course = course[2..-1]
        next if course.start_with?("Experimental College", "dept desc")
        course_arr = course.split('|')
        c = Course.build(course_arr)
        if delete
          course = Course.where(semcrn: c.semcrn, days: c.days, start_time: c.start_time, end_time: c.end_time, professor: c.professor)[0]
          if course
            hidden_courses << course.semcrn if course.status == "hidden"
            course.cancel
            if course.save
              puts "Cancelled course: #{c.semcrn} #{c.days} #{c.start_time} #{c.end_time} #{c.professor}"
            else
              puts "Can't cancel course (save failed): #{c.semcrn} #{c.days} #{c.start_time} #{c.end_time} #{c.professor}"
            end
          else
            puts "Can't cancel course (not found): #{c.semcrn} #{c.days} #{c.start_time} #{c.end_time} #{c.professor}"
          end
        else
          # this is an add
          matches = Course.where(semcrn: c.semcrn, status: 'cancelled')
          if matches.size > 0
            # grab info that could differ across different matching sections
            matches_days = matches.map{|m| m[:days]}
            matches_start_times = matches.map{|m| m[:start_time]}
            matches_end_times = matches.map{|m| m[:end_time]}
            matches_rooms = matches.map{|m| m[:room]}
            matches.each do |match|
              # copying over enrollments from old versions
              c.enroll ||= match.enroll
              c.csize ||= match.csize
              # copy over prof-created fields
              c.which_desc = match.which_desc unless match.which_desc.blank?
              c.prof_desc ||= match.prof_desc
              c.new_desc_action ||= match.new_desc_action
              c.prof_note ||= match.prof_note
              c.display_prof_note ||= match.display_prof_note
              c.notify_profs ||= match.notify_profs
              # copy over hidden status if necessary
              if hidden_courses.include?(match.semcrn)
                c.status = "hidden"
              end

              # do profs want to be notified of changes?
              unless match.notify_profs.blank?
                # make a list of fields being changed for the changed_fields thing
                changed_fields_str = ""
                changed_fields_str << match.changed_fields unless match.changed_fields.blank?
                if changed_fields_str.include? "cancelled"
                  temp = changed_fields_str.split("|")
                  temp.delete("cancelled")
                  changed_fields_str = temp.join("|")
                end
                Course.attribute_names.each do |k|
                  next if k == "created_at" || k == "updated_at" || k == "id" || k == "which_desc" || k == "status"
                  if match.send(k) != c.send(k)
                    case k
                    # deal with updating course descriptions and prof_desc's
                    when "descrip"
                      case match.new_desc_action
                      when "keep"
                        c.which_desc = "professor"
                      when "both"
                        c.which_desc = "both"
                      else # new_desc_action == "replace" or is blank
                        c.which_desc = "default"
                      end
                    when "days"
                      next if matches_days.include?(c.send(k))
                    when "start_time"
                      next if matches_start_times.include?(c.send(k))
                    when "end_time"
                      next if matches_end_times.include?(c.send(k))
                    when "room"
                      next if matches_rooms.include?(c.send(k))
                    end
                    unless changed_fields_str.include?(k)
                      changed_fields_str<<"|" unless changed_fields_str.blank?
                      changed_fields_str<<k
                    end
                  end
                end
                c.changed_fields = changed_fields_str
              end
              match.sever_relationships
              match.delete
            end
            if c.changed_fields
              # deal with any other sections of this course that are not being updated
              # they need to have the same recent_edit and changed_fields as the section being updated.
              others = Course.where(semcrn: c.semcrn)
              fields = c.changed_fields.split("|")
              others.each do |o|
                next if o.status == 'cancelled'
                fields = fields | o.changed_fields.split("|") unless o.changed_fields.blank?
              end
              fields_str = fields.join("|")
              c.changed_fields = fields_str
              others.each do |o|
                next if o.status == 'cancelled'
                o.changed_fields = fields_str
                o.recent_edit = c.recent_edit
                o.save
              end
            end

            #Checks if there is a course w/ same crn (such as lecture with lab)
            #Uses enrollment from that course as enrollment 
          else
            samecrnmatches = Course.where(semcrn: c.semcrn)
            if samecrnmatches.size > 0
              samecrnmatches.each do |match|
                # copy enrollments
                c.enroll ||= match.enroll
                c.csize ||= match.csize
                # do profs want to be notified of changes?
                unless match.notify_profs.blank? || match.changed_fields.blank?
                  c.changed_fields = match.changed_fields
                end
                # copy over prof-created fields
                c.which_desc ||= match.which_desc
                c.prof_desc ||= match.prof_desc
                c.new_desc_action ||= match.new_desc_action
                c.prof_note ||= match.prof_note
                c.display_prof_note ||= match.display_prof_note
                c.notify_profs ||= match.notify_profs
              end
            else
              puts("Could not find enrollments for #{c.semcrn} during add.")
              c.enroll = -1
              c.csize = -1 
            end
          end

          if c.save
            puts "Course #{c.semcrn} created"
          end
          c.generate_relationships(course_arr[10], course_arr[11], course_arr[12])
        end
      end
    end

    # enrollment and class size
    File.open(args[:enrollment_file], "r") do |f|
      f.each_line do |entry|
        if entry[0] == '>'
          entry = entry[2..-1]
          next if entry.start_with? 'crn'
          semester = Setting.get_val('current_semester')
          sem = ''
          case semester[0]
          when 'F'
            sem = 'f'
          when 'S'
            sem = 's'
          end
          sem << semester[-2..-1]
          entry_arr = entry.split('|')
          semcrn = "#{sem}_#{entry_arr[0]}"
          puts semcrn
          total_enroll = entry_arr[2]
          for i in 3..5 do
            unless entry_arr[i].blank?
              total_enroll = total_enroll.to_i + entry_arr[i].to_i
            end
          end
          courses = Course.where(semcrn:semcrn)
          if courses.size > 0
            courses.each do |c|
              c.update_size(entry_arr[1], total_enroll)
              c.save
            end
          else
            puts "Course #{semcrn} not found in DB"
          end
        end
      end
    end
  end
end

