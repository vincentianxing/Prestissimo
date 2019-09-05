module ApplicationHelper

  # builds the title for each page (title must be provided in each page)
  def full_title(page_title)
    base_title = "Prestissimo"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def display_cart?
		if !current_user.nil?
			logger.debug "called display_cart?"
			action = current_page?(root_path)
			logger.debug "course#index? #{action}"
			is_list = !current_user.course_list.blank?
			logger.debug "course_list? #{is_list}"
			action && is_list
		else
			false
		end
  end
    # variable to hold the current number of users
    def user_count 
	    @user_count ||= Setting.get_val('user_count')
    end

    def comment_count
	    @comment_count ||= Setting.get_val('comment_count')
    end

    def courses_last_updated
      @courses_last_updated ||= Setting.get_val('courses_last_updated')
    end

    def motd
      @motd ||= Setting.get_val('motd')
    end
end
