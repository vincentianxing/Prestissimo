namespace :db do
  desc 'rebuild the courses_professors DB table, optionally for only a specific semester'
  task :rebuild_courses_professors, [:force, :semester] => [:environment] do |t, args|
    args.with_defaults(:force => "", :semester => "")

    if args[:force] != "force"
      puts "Warning: If this task finds a course with a professor that does not exist in the database, it will skip over that professor. To force this task to create a new professor entry instead, re-run as 'rake db:rebuild_courses_professors[force]'."
    else
      puts "Running with 'force' enabled. New professor entries will be created as needed."
    end

    if args[:semester].blank?
      courses = Course.all
    else
      courses = Course.where(semester: args[:semester])
      if courses.empty?
        puts "Could not find any courses matching the semester '#{args[:semester]}'! Aborting task."
        next
      end
    end

    puts "Deleting all course-professor associations."
    courses.each do |c|
      if c.professors.clear
        #puts "Deleted professor associations for course #{c.short_title}, #{c.semester}."
      else
        puts "Unable to delete professor associations for course #{c.short_title}, #{c.semester}."
      end
    end
    puts "Finished deleting course-professor associations."

    puts "Rebuilding all course-professor associations."
    courses.each do |course|
      profs = course.professor.split(", ")
      profs.each do |prof|
        if prof =~ /^\s*$/
          next
        end
        name = prof.split(" ")
        if name.size < 2
          puts "#{course.title} appears to have a poorly formed professor name. Skipping to next professor."
          next
        elsif name[1].include? "Staff"
          # skip "professors" like OCEAN Staff, A&S Staff, Con Staff, etc.
          next
        else
          p = Professor.where(fname: name[0], lname: name[1..-1].join(" "))[0]
        end

        unless p
          if args[:force] == "force"
            puts "Professor not found. Creating new professor with name: #{name[0]} #{name[1..-1].join(" ")}." 
            p = Professor.new
            p.fname = name[0]
            p.lname = name[1..-1].join(" ")
            if p.save
              puts "Professor #{p.fname} #{p.lname} created."
            else
              puts "Unable to save professor #{p.fname} #{p.lname}."
              next
            end
          else
            puts "Professor #{name[0]} #{name[1..-1].join(" ")} not found. Skipping to next professor."
            next
          end
        end

        course.professors << p
        #puts "Associated professor #{p.fname} #{p.lname} with course #{course.short_title}, #{course.semester}."
      end
    end
    puts "Finished rebuilding course-professor associations."
  end
  
  desc 'rebuild the associations between departments and professors'
  task :rebuild_departments_professors => [:environment] do
    puts "Deleting all department-professor associations."
    Department.all.each do |department|
      if department.professors.clear
        puts "Deleted professor associations for the #{department.dept_long} department."
      else
        puts "Unable to delete professor associations for the #{department.dept_long} department."
      end
    end
    puts "Finished deleting department-professor associations."

    puts "Rebuilding all department-professor associations."
    Department.all.each do |department|
      prof_set = Set.new() # use a set to avoid adding duplicate department_professor entries
      department.hubcourses.each do |hc|
        hc.courses.each do |course|
          course.professors.each do |prof|
            prof_set.add(prof)
          end
        end
      end
      prof_set.each do |p|
        department.professors << p
        puts "Associated professor #{p.fname} #{p.lname} with the #{department.dept_long} department."
      end
    end
    puts "Finished rebuilding department-professor associations."
  end

  desc 'rebuild the associations between courses and hubcourses'
  task :rebuild_courses_hubcourses => [:environment] do

    puts "Deleting all hubcourse-course associations."
    Hubcourse.all.each do |hubcourse|
      unless hubcourse.courses.clear
        puts "Unable to delete course associations for hubcourse #{hubcourse.cname}"
      end
    end
    puts "Finished deleting hubcourse-course associations."

    puts "Rebuilding hubcourse-course associations."
    Course.all.each do |course|
      hubid = "#{course.dept} #{course.cnum}"
      hc = Hubcourse.find_by_hub_id(hubid)
      unless hc
        puts "No Hubcourse exists with the hub id #{hubid}."
        next
      end
      unless course.hubcourse == hc
        course.hubcourse = hc
        puts "Set #{hc.cname} as the Hubcourse for #{course.short_title}."
      end
      unless hc.courses.include? course
        hc.courses << course
        puts "Added #{course.short_title} to the list of courses for the Hubcourse #{hc.cname}."
      end
    end
  end

  desc "fix course enrollments"
  task :fix_enrollments => [:environment] do
    fixed_courses = Hash.new()
    Course.all.each do |course|
      unless fixed_courses[course.semcrn]
        puts "Setting enrollments for courses with semcrn: #{course.semcrn}"
        courses = Course.where(semcrn:course.semcrn)
        courses_with_enrollments = courses.select{|c| !c.enroll.nil?}.sort_by{|c| c.enroll}
        if courses_with_enrollments.size == 0
          puts "\tNo courses with enrollment values were found for the semcrn #{course.semcrn}."
          next
        end
        enroll = courses_with_enrollments.last.enroll
        csize = courses_with_enrollments.last.csize

        if courses_with_enrollments.size > 1
          puts "\tThere are multiple courses with enrollment values for the semcrn #{course.semcrn}:"
          courses_with_enrollments.each_with_index do |c, i|
            puts "\tCourse #{i} meets on #{c.days} from #{c.start_time.strftime("%I:%M %p")} to #{c.end_time.strftime("%I:%M %p")} and has an enrollment of #{c.enroll} and a max enrollment of #{c.csize}."
          end
          puts "\tChoosing course with largest enrollment. Enrollment is now #{enroll} and max enrollment is #{csize}."
        end

        courses.each do |c|
          c.update_size(csize, enroll)
          c.save
        end
        fixed_courses[course.semcrn] = true
      end
    end
    puts "Finished fixing course enrollments!"
  end

  desc 'rebuild all associations'
  task :rebuild_associations => [:rebuild_courses_professors, :rebuild_courses_hubcourses, :rebuild_departments_professors] do
  end
end
