module CoursesHelper
  def find_by_crn(course_list, semcrn)
    return nil unless Array.try_convert(course_list)

    @course
    course_list.each do |c|
      @course = c if c.semcrn == semcrn
      break if @course
    end
    @course
  end

  def translate_mod(mod_num)
    mod = case mod_num
          when 1
            'First'
          when 2
            'Second'
          when 3
            'Full'
          when 4
            'Special'
          else
            ''
          end
    mod
  end

  # TODO: This is contrary to other uses of the name translate_semester. Rename accordingly (expand_semester?)
  def translate_semester(semester)
    s = 'Fall' if semester[0] == 'f'
    s = 'Spring' if semester[0] == 's'
    s = 'Summer' if semester[0] == 'u'
    s << " 20#{semester[1..2]}"
  end

  def current_semester
    @current_semester ||= Setting.get_val('current_semester')
  end

  # More efficient link generation using a hash table of previously requested links
  def get_link(type, value)
    key = "#{type}:#{value}"
    @links ||= {}
    unless @links[key]
      case type
      when 'obiemaps_prof'
        @links[key] = "http://obiemaps.oberlin.edu/faculty/#{value.fname.downcase}-#{value.lname.downcase}"
      when 'obiemaps_course'
        @links[key] = 'http://obiemaps.oberlin.edu/courses/' + value.title.gsub(/[:,]/, '').gsub(/\s+/, '-').downcase
      end
    end
    @links[key]
  end
end
