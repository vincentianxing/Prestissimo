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
    @user_count ||= User.all.count
  end

  def comment_count
    @comment_count ||= Comment.all.count
  end

  def hubcourse_count
    @hubcourse_count ||= Hubcourse.all.count
  end

  def visit_count
    @visit_count ||= Ahoy::Visit.where(started_at: 1.weeks.ago..Time.now).count
  end

  def search_count
    @search_count ||= Ahoy::Event.where(name: "Course search", time: 1.weeks.ago..Time.now).count
  end

  def courses_last_updated
    @courses_last_updated ||= Setting.get_val("courses_last_updated")
  end

  def motd
    @motd ||= Setting.get_val("motd")
  end

  # builds a MYSQL query string based on user input
  # takes in a user input string, str, and an array of sql fields to search
  # builds a string that will search for all of the user's search terms in any of the fields
  # ex: (field1 LIKE %term1% OR field2 LIKE %term1%) AND (field1 LIKE %term2% OR field2 LIKE %term2%)
  #
  # note: a field called "email" is a special case and uses regexps to ignore stuff after the '@' in the email
  def make_query_string(str, fields, any)
    raise ArgumentError.new "empty search string" if str.blank?
    cond = "AND"
    cond = "OR" if any

    str.strip! #remove leading/trailing whitespace from user input.
    qs = "("
    str.scan(/'.+?'|".+?"|[^ ]+/).map { |e| e.gsub /^['"]|['"]$/, "" }.each do |s|
      qs << ") #{cond} (" unless qs.eql? "("
      # search by all fields
      fs = ""
      fields.each do |f|
        fs << " OR " unless fs.blank?
        if f.eql? "email"
          fs << " email RLIKE " + ActiveRecord::Base.connection.quote("^[^\@]*" + Regexp.escape(s))
        else
          fs << " #{f} LIKE " + ActiveRecord::Base.connection.quote("%" + s + "%")
        end
      end
      qs << fs
    end
    qs << ")"
  end
end
