class CoursesController < ApplicationController

  # CREATE action: empty
  def create
  end

  # NEW action: empty
  def new
  end

  # EDIT action: empty
  def edit
  end

  # UPDATE action: empty
  def update
  end

  # INDEX action: used to render the javascript and search results
  def index
    #if !cookies[:mobile_format].nil? && is_mobile_device?
    #	session[:mobile_view] = true
    #end
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
      qs = likeAppend("dept", "#{params[:dept]}", qs)
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
      wr = "WR"
      qs = likeAppend("proficiencies", "#{wr}", qs)
    end

    if !(params[:qp].blank?)
      qp = "QP"
      qs = likeAppend("proficiencies", "#{qp}", qs)
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

    #Module Conditionals
    # Use 'LIKE' comparison
    #  Converts from checkbox 'ON'/'OFF' to integers. Modules stored as:
    #  1: first mod
    #  2: second mod
    #  3: full semester
    #  4: special meeting times
    if !(params[:mod1].blank?)
      mod1 = 1
      qs = likeAppend("mods", "#{mod1}", qs)
    end

    if !(params[:mod2].blank?)
      mod2 = 2
      qs = likeAppend("mods", "#{mod2}", qs)
    end

    if !(params[:full].blank?)
      full = 3
      qs = likeAppend("mods", "#{full}", qs)
    end

    if !(params[:special].blank?)
      special = 4
      qs = likeAppend("mods", "#{special}", qs)
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

    #Number of Credits Conditionals
    # Uses numerical comparisons, and searches in an inclusive range
    if !(params[:min_credits].blank?)
      qs = numAppend("crmin", "#{params[:min_credits]}", ">=", qs)
    end

    if !(params[:max_credits].blank?)
      qs = numAppend("crmax", "#{params[:max_credits]}", "<=", qs)
    end

    #CRN Conditional
    # Uses 'LIKE' comparison
    if !(params[:crn].blank?)
      qs = likeAppend("crn", "#{params[:crn]}", qs)
    end

    #Time Conditionals
    # If start is queried but end is blank, searches for courses starting
    #  at exactly the given time
    # If both start and end are specified, searches for courses falling
    #  completely in the range, endpoints inclusive
    # If only end is specified, searches for courses ending at exactly
    #  the given time
    #Start Time Conditionals
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
      qs = numAppend("end_time", "#{end_hour}", "=", qs)
    elsif (!start_hour.blank?)
      qs = numAppend("start_time", "#{start_hour}", "=", qs)
    end

    #Course Level Conditionals
    # Uses a numerical comparison
    # Given only a numerical level, searches for courses in that level range
    # Given a level and a comparator, searches for courses, compared to
    #  the specified level
    #Set the comparator
    comp = ""
    if !(params[:course_comparison].blank?)
      comp = params[:course_comparison]
    end

    #Set the level
    level = ""
    if !(params[:course_level].blank?)
      level = params[:course_level][0..2]
    end

		#Build the query, depending on what values are blank
		if (!comp.blank? && !level.blank?)
			if comp == ">="
				qs = numAppend("cnum", "#{level}", comp, qs)
			elsif comp == "="
				top = Integer(level)+99
				qs = betweenAppend("cnum", "#{level}", "#{top}", qs)
			else
			  top = Integer(level)+99
			  qs = numAppend("cnum", "#{top}", comp, qs)
			end
		elsif (!level.blank?)
			top = Integer(level)+99
			qs = betweenAppend("cnum", "#{level}", "#{top}", qs)
		end
    
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

    # Removes the trailing ' AND ' from the query string
    5.times { qs.chop! }

    # Performs the search, using the built query string
    @courses = Course.find(:all, :conditions => qs)
    if params[:cart_id]
      @cart = Cart.find_by_cartid(params[:cart_id])
      @courses = tag_conflicts(@courses,@cart.get_courses) unless @cart.courses.blank?
    end
    # Renders the search results
    respond_to do |format|
      format.mobile
      format.html
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
      cart_courses.each do |cart|
	next if result.semester != cart.semester
	# they are not a conflict if they're the same course
	if result.crn == cart.crn
	    result.descrip = "<span class=\"course_conflict\">This course is already in your cart.</span><br>" + result.descrip
	  next
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
	    result.descrip = "<span class=\"course_conflict\">This course conflicts with #{cart.dept}-#{cart.cnum}.</span><br>" + result.descrip
	    break
	  end
	end
      end
    end
    courses
  end
end
