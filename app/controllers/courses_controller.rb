class CoursesController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::TextHelper

  # CREATE action: empty
  def create
  end

  # NEW action: empty
  def new
  end

  # EDIT action: empty
  def edit
    return redirect_to root_path unless signed_in? && faculty_user?(current_user)
    @courses = Course.where(semcrn: params[:semcrn])
    return redirect_to error_404_path unless @courses
    @sections = Course.where(dept: @courses.first.dept, cnum: @courses.first.cnum, semester: @courses.first.semester)
    @sections.sort_by!{|c| c.crn}
    @course_arr = [@courses, @sections]
    @course_arr
  end

  # UPDATE action: empty
  def update
    had_error = false
    @course = Course.find(params[:id])
    @courses = Course.where(semcrn: @course.semcrn).to_a

    #add checked sections into the courses list
    unless params[:sections].nil?
      params[:sections].keys.each do |s|
        @courses=@courses|Course.where(semcrn: s).to_a
      end
    end

    #All fields get applied to all checked sections except notify_profs and changed_fields
    section_hash = Hash.new
    @courses.each do |c|
      section_hash[c.semcrn]=[c.changed_fields,c.notify_profs]
    end

    updates = params[:course].clone
    if updates[:display_prof_note]=="0"
      updates[:display_prof_note]=false;
    else
      updates[:display_prof_note]=true;
    end

    updates.delete("status")
    updates.delete("notify_profs")
    sec_update=Hash.new

    @courses.each do |sec|
      
      #hide course 
      if params[:course][:status]=="1"
        if sec.status.blank?
          section_hash[sec.semcrn][0]||=""
          section_hash[sec.semcrn][0]<<"|"unless section_hash[sec.semcrn][0].blank?
          section_hash[sec.semcrn][0]<<"status" unless section_hash[sec.semcrn][0].include?("status")
        end
        sec.status="hidden" unless sec.status=="cancelled"
      #unhide course
      else
        if sec.status=="hidden"
          section_hash[sec.semcrn][0]||=""
          section_hash[sec.semcrn][0]<<"|"unless section_hash[sec.semcrn][0].blank?
          section_hash[sec.semcrn][0]<<"status" unless section_hash[sec.semcrn][0].include?("status")
        end
        sec.status="" unless sec.status=="cancelled" 
      end

      #add the fields in the updates hash to the list of changed fields for the section
      updates.keys.each do |k|
        if updates[k] != sec.send(k)
          section_hash[sec.semcrn][0]||=""
          unless section_hash[sec.semcrn][0].include?(k)
            section_hash[sec.semcrn][0]<<"|" unless section_hash[sec.semcrn][0].blank?
            section_hash[sec.semcrn][0]<<k unless section_hash[sec.semcrn][0].include?(k)
          end
        end
      end

      #It won't change the field if it is the empty string, so this sets it to nil so it can be edited
      sec.notify_profs=nil if sec.notify_profs!=nil && sec.notify_profs.empty?

      #Adds/removes the professor to notify profs
      if params[:course][:notify_profs]=="1"
        temp_str = sec.notify_profs 
        temp_str||=""
        unless temp_str.include?(current_user.email)
          temp_str<<"|" unless temp_str.blank?
          temp_str<<current_user.email
        end
        section_hash[sec.semcrn][1]=temp_str
      elsif !sec.notify_profs.blank? 
        temp_arr = sec.notify_profs.split("|")
        temp_arr.delete(current_user.email)
        temp_str=temp_arr.join("|")
        section_hash[sec.semcrn][1]=temp_str
      end
    end

    updates[:recent_edit]=current_user.email
    
    #Updates the courses
    @courses.each do |c|
      updates[:changed_fields]=section_hash[c.semcrn][0]
      updates[:notify_profs]=section_hash[c.semcrn][1]
      temp_bool=c.update_attributes(updates)
      had_error||=!temp_bool
    end

    if !had_error
      flash[:success]="Course(s) successfully updated!"
      redirect_to course_edit_path(@course.semcrn)
    else
      redirect_to course_edit_path(@course.semcrn),:notice=>"Course(s) could not be updated. Please contact the prestissimo managers."
    end
  end

  # INDEX action: used to render the javascript and search results
  def index
    #if !cookies[:mobile_format].nil? && is_mobile_device?
    #	session[:mobile_view] = true
    #end
    unless cookies[:cart]
       @cart = Cart.new
      if @cart.save
        cookies.permanent[:cart] = @cart.cartid
      end
      @cart.total_credits = 0
      @cart.save
    end
    unless params[:value].blank?
      @courses = Cart.find_by_cartid(params[:value]).get_courses
    end
    respond_to do |format|
      format.mobile
      format.js
      format.html
    end
  end

  # SEARCH action: performs course search
  #  - builds a 'query string,' used to query SQL database, based on form
  #     field input
  def search
    qs = '' # Query String
#    qs = 'SELECT courses.* FROM courses WHERE (' # Query String

    #CRN Conditional
    # Searches for the course whose CRN = the query
    # Skips other fields when used
    if !(params[:crn].blank?)
      qs = "crn = #{ActiveRecord::Base.connection.quote("#{params[:crn]}")} AND "

      #Semester Select Conditional
      # Uses 'LIKE' comparison
      # Converts from human-readable semester format to table semester shorthand
      #  FORMAT: [First letter of Season][Last two digits of Year]
      #  F12 - Fall 2012
      #  S12 - Spring 2012
      #  and so on
      if !(params[:semester].blank?)
        semester = translate_semester(params[:semester])
        qs = likeAppend("semester", "#{semester}", qs)
      end

      # Removes the trailing ' AND ' from the query string
      5.times { qs.chop! }
    else # skips all other fields when a CRN is specified

      #Course Name Conditional
      # Uses 'LIKE' comparison
      if !(params[:cname].blank?)
        qs = likeAppend("title", "#{params[:cname]}", qs)
      end

      #Professor Conditional
      # Uses 'LIKE' comparison
      if !(params[:professor].blank?)
        qs = likeAppend("professor", "#{params[:professor]}", qs)
      end

      #Department Conditional
      # Uses 'LIKE' comparison
      if !(params[:dept].blank?)
        dept = "#{params[:dept]}".to_s.split(" ")
        asize = dept.length-1;
        (0..asize).each do |c|
          if (asize == 0)
            qs = likeAppend("dept", dept[c], qs)
          elsif (c == 0)
            qs = orAppend("(dept", dept[c], qs)
          elsif (c < asize)
            qs = orAppend("dept", dept[c], qs)
          else
            qs = likeAppendMulti("dept", dept[c], qs)
          end
        end
      end

      #Semester Select Conditional
      # Uses 'LIKE' comparison
      # Converts from human-readable semester format to table semester shorthand
      #  FORMAT: [First letter of Season][Last two digits of Year]
      #  F12 - Fall 2012
      #  S12 - Spring 2012
      #  and so on
      if !(params[:semester].blank?)
        semester = translate_semester(params[:semester])
        qs = likeAppend("semester", "#{semester}", qs)
      end

      #Proficiency Conditionals
      # Use 'LIKE' comparison
      #  Converts from checkbox 'ON'/'OFF' format to string
      #  Profs. stored as a string containing all credited profs,
      #  i.e. "CD,WR"

      if !(params[:cd].blank?)
        cd = "CD"
        qs = likeAppend("proficiencies", "#{cd}", qs)
      end

      if !(params[:wr].blank?)
        if (params[:profic]=="wadv")
          qs = likeAppend("proficiencies", "WAdv", qs)
        elsif (params[:profic]=="wint")
          qs = likeAppend("proficiencies", "WInt", qs)
        else
          qs = orAppend("(proficiencies", "WInt", qs)
          qs = orAppend("proficiencies", "WR", qs)
          qs = likeAppendMulti("proficiencies", "WAdv", qs)
        end
      end

      if !(params[:qfr].blank?)
        qfr = "QFR"
        qs = orAppend("(proficiencies", "QP", qs)
        qs = likeAppendMulti("proficiencies", "#{qfr}", qs)
      end

      #Day of the Week Conditionals
      # Use 'LIKE' comparison
      #  Converts from checkbox 'ON'/'OFF' format to string,
      #  single letter day notation, using PRESTO standard [MWTRFSU]
      if !(params[:monday].blank?)
        monday = "M"
        qs = likeAppend("days", "#{monday}", qs)
      end

      if !(params[:tuesday].blank?)
        tuesday = "T"
        qs = likeAppend("days", "#{tuesday}", qs)
      end

      if !(params[:wednesday].blank?)
        wednesday = "W"
        qs = likeAppend("days", "#{wednesday}", qs)
      end

      if !(params[:thursday].blank?)
        thursday = "R"
        qs = likeAppend("days", "#{thursday}", qs)
      end

      if !(params[:friday].blank?)
        friday = "F"
        qs = likeAppend("days", "#{friday}", qs)
      end

      if !(params[:saturday].blank?)
        saturday = "S"
        qs = likeAppend("days", "#{saturday}", qs)
      end

      if !(params[:sunday].blank?)
        sunday = "U"
        qs = likeAppend("days", "#{sunday}", qs)
      end

      # Full Course Conditionals
      # Use 'LIKE' comparison
      if (params[:fc]=="fc")
        fc = "Full Course"
        qs = likeAppend("full_course", "#{fc}", qs)
      elsif (params[:fc]=="hc")
        hc = "Half Course"
        qs = likeAppend("full_course", "#{hc}", qs)
      elsif (params[:fc]=="cc")
        cc = "Co-Curricular"
        qs = likeAppend("full_course", "#{cc}", qs)
      end

      #Module Conditionals
      # Use 'LIKE' comparison
      #  Converts from checkbox 'ON'/'OFF' to integers. Modules stored as:
      #  1: first mod
      #  2: second mod
      #  3: full semester
      #  4: special meeting times
      if !(params[:module].blank?)
        mod=0;
        if(params[:module]=="mod1")
          mod = 1
        elsif(params[:module]=="mod2")
          mod = 2
        elsif(params[:module]=="full")
          mod = 3
        elsif(params[:module]=="spec")
          mod = 4
        end
        if(mod>0)
          qs = likeAppend("mods", "#{mod}", qs)
        end
      end

      #Attribute Conditionals
      #Assumed: max value is always filled, where credit for attribute is given
      # Uses a numerical comparison, and returns all classes where the selected
      #  attribute gives strictly greater than 0 credits
      if !(params[:ns].blank?)
        ns = "NS"
        qs = likeAppend("distributions", "#{ns}", qs)
      end

      if !(params[:ss].blank?)
        ss = "SS"
        qs = likeAppend("distributions", "#{ss}", qs)
      end

      if !(params[:hu].blank?)
        hu = "HU"
        qs = likeAppend("distributions", "#{hu}", qs)
      end

      #Con Attribute Conditionals
      if !(params[:cndp].blank?)
        qs = likeAppend("distributions", "CNDP", qs)
      end

      if !(params[:ddhu].blank?)
        qs = likeAppend("distributions", "DDHU", qs)
      end

      #Number of Credits Conditionals
      # Uses numerical comparisons, and searches in an inclusive range
      if !(params[:min_credits].blank?)
        qs = numAppend("crmin", "#{params[:min_credits]}", ">=", qs)
      end

      
      if !(params[:max_credits].blank?)
        params[:max_credits]="99" if params[:max_credits].to_i>8
        qs = numAppend("crmax", "#{params[:max_credits]}", "<=", qs)
      end

      #Time Conditionals
      # Somewhat more intuitively: if "start after" is entered, will list all classes >= given start time.
      # If "end before" is specified, will list all classes <= the given end time.
      #Start Time Conditionals
      unless (params[:start_hour]=="7" && params[:start_minute]="00" &&  params[:end_hour]=="22" && params[:end_minute]=="00")
        start_hour = ""
        if !(params[:start_hour].blank?)
          start_hour << params[:start_hour]+":"
          if !(params[:start_minute].blank?)
            start_hour << params[:start_minute] << ":00"
          else
            start_hour << "00:00"
          end
        end

        #End Time Conditionals
        end_hour = ""
        if !(params[:end_hour].blank?)
          end_hour << params[:end_hour]+":"
          if !(params[:end_minute].blank?)
            end_hour << params[:end_minute] << ":00"
          else
            end_hour << "00:00"
          end
        end

        #Build the query string for times
        if (!end_hour.blank? && !start_hour.blank?)
          qs = numAppend("start_time", "#{start_hour}", ">=", qs)
          qs = numAppend("end_time", "#{end_hour}", "<=", qs)
        elsif (!end_hour.blank?)
          qs = numAppend("end_time", "#{end_hour}", "<=", qs)
        elsif (!start_hour.blank?)
          qs = numAppend("start_time", "#{start_hour}", ">=", qs)
        end
      end

      #Course Level Search
      unless params[:min_course_level].blank? && params[:max_course_level].blank?
        min_level = Integer(params[:min_course_level])
        if min_level == 0
          min_level = "000"
        end
        max_level = Integer(params[:max_course_level])
        if max_level == 99
          max_level = "099"
        end
        if max_level == 1000
          max_level = "999"
        end
        qs = betweenAppend("cnum", "#{min_level}", "#{max_level}", qs)
      end

      #Course Size Search
      unless params[:min_course_size].blank? && params[:max_course_size].blank?
        min_size = Integer(params[:min_course_size])
        max_size = Integer(params[:max_course_size])
        qs = betweenAppend("csize", "#{min_size}", "#{max_size}", qs)
      end

      #Course Enrollment Search
      unless params[:min_course_enrollment].blank? && params[:max_course_enrollment].blank?
        min_enrollment = Integer(params[:min_course_enrollment])
        max_enrollment = Integer(params[:max_course_enrollment])
        qs = betweenAppend("enroll", "#{min_enrollment}", "#{max_enrollment}", qs)
      end

      # Course description and notes keyword search!
      unless params[:keyword].blank?
        temp =""
        temp = make_query_string(params[:keyword], ["descrip", "short_title", "title", "xlist1", "xlist2", "xlist3", "prereqs", "dept", "dept_long", "prof_desc", "prof_note"], params[:key_button] == "any")
        qs << "( #{temp} )  AND "
      end

=begin
      # courses last altered since
      unless params[:date][:year].blank? && params[:date][:month].blank? && params[:date][:day].blank?
        querydate = ""
        if params[:date][:year].blank?
          querydate << DateTime.now.year.to_s
        else
          querydate << params[:date][:year]
        end
        querydate << "-"
        if params[:date][:month].blank?
          if params[:date][:day].blank?
            querydate << "01-01"
          else
            querydate << DateTime.now.month.to_s + "-" + params[:date][:day]
          end
        else
          if params[:date][:day].blank?
            querydate << params[:date][:month] + "-01"
          else
            querydate << params[:date][:month] + "-" + params[:date][:day]
          end
        end
        querydate << " 00:00:00"
        logger.debug querydate

        qs = qs + "last_changed >= '#{querydate}' AND "
      end
=end

      # Removes the trailing ' AND ' from the query string
      5.times { qs.chop! }
      # Adds "order by" in query string
      # qs << ") ORDER BY dept, cnum, section"
      # Course.set_scope("dept, cnum, section");
      # Performs the search, using the built query string
    end
    @courses = Course.all(:conditions => qs)
#    @courses = Course.find_by_sql(qs)
    if params[:cart_id]
      @cart = Cart.find_by_cartid(params[:cart_id])
      @courses = tag_conflicts(@courses,@cart.get_courses) unless @cart.courses.blank?
    end
    # highlight the keywords from the keyword field in the course results
    @courses = highlight_keywords(@courses, params[:keyword]) unless params[:keyword].blank?
    # Hide cancelled courses unless the crn field was chosen.
    @courses.delete_if {|c| c.status == "cancelled"} if params[:crn].blank?
    @courses.delete_if {|c| c.status == "hidden"} unless signed_in? && faculty_user?(current_user)
    @links = Hash.new()
    # Renders the search results
    respond_to do |format|
      format.mobile { redirect_to root_path }
      format.html { redirect_to root_path }
      format.js
    end
  end ##END SEARCH##



  private ####### Private helper methods ########
  #NOTE:
  # All Append methods escape/quote user-input values, using packaged ruby 
  #  methods.

  # Appends a 'LIKE' comparison to the end of the specified query string
  #  qs: query string, string object
  #  field: the name of the table field being queried
  #  value: value used for comparison, can be any type
  # Returns a string
  def likeAppend(field, value, qs)
    qs << field+' LIKE '+ActiveRecord::Base.connection.quote("%"+value+"%")+' AND '
  end
  
  def likeAppendMulti(field, value, qs)
    qs << field+' LIKE '+ActiveRecord::Base.connection.quote("%"+value+"%")+') AND '
  end

  # Appends an 'OR' comparison to the end of the specified query string
  #  qs: query string, string object
  #  field: the name of the table field being queried
  #  value: value used for comparion, can be any type
  # Returns a string
  def orAppend(field, value, qs)
    qs << field+' LIKE '+ActiveRecord::Base.connection.quote("%"+value+"%")+' OR '
  end

  # Appends a numerical comparison to the end of the specified query string
  #  qs: query string
  #  field: name of the table field being queried
  #  value: value used for comparison
  #  comparator: a numerical comparison operator, i.e. >, <, >=, etc.
  # Returns a string
  def numAppend(field, value, comparator, qs)
    qs << field+' '+comparator+' '+ActiveRecord::Base.connection.quote(value)+' AND '
  end

  # Appends a 'BETWEEN' comparison to the end of the specified query string
  #  qs: query string
  #  field: name of the table field being queried
  #  val1: the smaller/first of the two values used for comparison
  #  val2: the larger/second of the two values used for comparison
  # Returns a string
  def betweenAppend(field, val1, val2, qs)
    qs << field+' BETWEEN '+ActiveRecord::Base.connection.quote(val1)+' AND '+ActiveRecord::Base.connection.quote(val2)+' AND '
  end

  def correct_prof_user
    redirect_to(root_path) if !signed_in?
    redirect_to(root_path) unless faculty_user?(current_user)
  end

  def translate_semester(semester)
    sem = semester.split(" ")
    ret = "f" if sem[0] == "Fall"
    ret = "s" if sem[0] == "Spring"
    ret << sem[1][2..3]
  end

  # compares the search results to the user's cart and tags the conflicting courses
  def tag_conflicts(courses,cart_courses)
    # compare each course and cart entry for conflicts

    courses.each do |result|
      temp_descrip=""
      temp_prof_desc=""
      cart_courses.each do |cart|
	next if result.semester != cart.semester
	# they are not a conflict if they're the same course
        conflict_message = "<span class=\'course_in_cart\'>This course is already in your cart.</span><br>" 
	if result.crn == cart.crn
          if result.which_desc == "professor"
	    unless temp_prof_desc.include?("This course is already in your cart")
	      temp_prof_desc << conflict_message
            end
            next
          else
	    unless temp_descrip.include?("This course is already in your cart")
	      temp_descrip << conflict_message
	    end
	    next
          end
	end
	# no conflict if times are nil
	next if (result.start_time.nil?) || (result.end_time.nil?) || (cart.start_time.nil?) || (cart.end_time.nil?)
	# if they're in different modules, there is no conflict
	next if result.mods == 1 && cart.mods == 2
	next if result.mods == 2 && cart.mods == 1
	# if they occur at the same time, should compare days
	next unless (result.start_time >= cart.start_time && result.start_time <= cart.end_time) || (result.end_time >= cart.start_time && result.end_time <= cart.end_time) || (result.start_time < cart.start_time && result.end_time > cart.end_time)
	# compare the days                
	result.days.each_char do |day|
	  if cart.days.include? day
            if result.which_desc == "professor" && !temp_prof_desc.include?("This course conflicts with #{cart.dept}-#{cart.cnum}") 
              temp_prof_desc << "<span class=\"course_conflict\">This course conflicts with #{cart.dept}-#{cart.cnum}.</span><br>"
            break
            elsif !temp_descrip.include?("This course conflicts with #{cart.dept}-#{cart.cnum}")
              temp_descrip << "<span class=\"course_conflict\">This course conflicts with #{cart.dept}-#{cart.cnum}.</span><br>"
              break
            end
	  end
	end
      end
      
      unless temp_prof_desc.blank?
        temp_prof_desc << "<span class=\"expanded_course_header\">Professor Description:</span>"
        temp_prof_desc << simple_format(result.prof_desc)
        result.prof_desc = temp_prof_desc
      end
      unless temp_descrip.blank?
        temp_descrip << "<span class=\"expanded_course_header\">Registrar Description:</span>"
        temp_descrip << "<p>"
        temp_descrip << result.descrip.html_safe
        temp_descrip << "</p>"
        result.descrip = temp_descrip
      end

    end
    courses
  end

  # highlights the keywords searched for in course results
  def highlight_keywords(courses, keywords)
    keywords.strip!
    keys = keywords.scan(/'.+?'|".+?"|[^ ]+/).map { |e| e.gsub /^['"]|['"]$/, '' }.map { |k| Regexp.escape(k) }
    courses.each do |result|
      [:descrip, :short_title, :title, :xlist1, :xlist2, :xlist3, :prereqs, :dept, :dept_long, :prof_desc, :prof_note].each do |field|
        result.send(field).gsub!(/#{keys.join('|')}/i, '<span class=highlight>\0</span>') unless result.send(field).blank?
      end
    end
    courses
  end
end
