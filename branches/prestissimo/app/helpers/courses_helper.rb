module CoursesHelper

  def find_by_crn(course_list, semcrn)
    return nil unless Array.try_convert(course_list)
    @course
    course_list.each do |c|
      @course = c if c.semcrn = semcrn
      break if @course
    end
    @course
  end

  def translate_mod(mod_num)
    case mod_num
    when 1
      mod = "First"
    when 2
      mod = "Second"
    when 3
      mod = "Full"
    when 4
      mod = "Special"
    else
      mod = ""
    end
    mod
  end

	def translate_semester(semester)
		s = "Fall" if semester[0] == "f"
		s = "Spring" if semester[0] == "s"
		s << " 20#{semester[1..2]}"
	end

	def current_semester
		@current_semester ||= Setting.get_val("current_semester")
	end
end
