class CartsController < ApplicationController

  # creates a new cart with courses in it
  def create
    @cart = Cart.new
    courses = ""
    if params[:courses]
      params[:courses].each do |key, value|
        courses << " " + key.to_s unless courses.include? key.to_s
      end
      courses.strip!
    end
    @cart.set_courses(courses)
    @cart_courses = Array.new
    if @cart.save
      cookies.permanent[:cart] = @cart.cartid
      @cart_courses = @cart.get_courses
    else
      @cart_courses = nil
    end
    @cart.total_credits = 0
    @cart_courses
    @cart.save
  end

  # deletes a cart
  def destroy
    @cart = Cart.find_by_cartid(params[:id])
    cookies.delete :cart if cookies[:cart]
    @cart.destroy
  end

  # gets courses from a cart
  def show
    @cart = Cart.find_by_cartid(params[:id])
    return redirect_to error_404_path unless @cart
    @cart_courses = @cart.get_courses
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
      format.csv { render plain: @cart.to_csv }
    end
  end

  # :category: Adding Courses To Cart
  # This adds the selected courses to the user's cart
  #
  # Parameter: :courses, which are passed in from _search_results_template.html.erb
  # in the submit_tag call.
  # This creates a PUT request to this controller (somehow), which gets
  # routed to this method with :courses being a hashmap of course crns.
  def update
    @cart = Cart.find_by_cartid(params[:id])
    if params[:courses]
      error = false
      exceed = false
      @hours = 0
      courses = @cart.courses.clone if @cart.courses
      courses_before_add = courses.clone if courses
      courses_before_add ||= ""
      params[:courses].each do |key, value|
        if courses.nil?
          courses = key.to_s.dup
          sem = key.to_s.dup
        else
          error = true if (courses.include? key.to_s)
          courses << " " + key.to_s unless courses.include? key.to_s
          sem = key.to_s.dup
        end
        courses.strip!
        @message = nil
        if courses.length > 16777214
          #message to pass to update.js
          @message = "Add failed: too many courses in your cart!"
          courses = courses_before_add.clone
          exceed = true
          break
        end
        course = Course.find_by_semcrn(sem)
        if course.crmax != course.crmin
          (@hours += course.crmin - course.crmax) unless error == true
        else
          (@hours += course.crmax) unless error == true
        end
        error = false
      end
      if exceed
        @cart_courses = @cart.get_courses
        @cart_courses
      else
        total_credits = @cart.total_credits.to_f
        total_credits += @hours
        @cart.total_credits = total_credits
        @cart.update!(total_credits: total_credits)
        @cart.set_courses(courses)
        @cart_courses = Array.new
        if @cart.save
          @cart_courses = @cart.get_courses
        else
          @cart_courses = nil
        end
        @cart_courses
      end
    else
      @cart_courses = @cart.get_courses
    end
  end

  # :category: Adding Courses To Cart
  # This adds the selected courses to the user's cart
  # This method only gets called when adding courses from a department
  # page or a HubCourse page. This method is virtually the same
  # as the update method
  #
  def add
    @cart = Cart.find_by_cartid(params[:id])
    courses = @cart.courses.clone if @cart.courses
    courses ||= ""
    courses_before_add = courses.clone
    courses << " " + params[:semcrn] unless courses.include? params[:semcrn]
    courses.strip!
    @message = nil
    if courses.length > 16777214
      #chop off the class that was just added
      #courses.gsub!(/ .{7,10}$/, '')

      #message to pass to add.js
      @message = "Too many courses in your cart!"
      courses = courses_before_add
    end
    @hours = 0

    params[:courses].each do |c|
      course = Course.find_by_semcrn(c)
      if course.crmax != course.crmin
        (@hours += course.crmin - course.crmax) unless courses_before_add.include? params[:semcrn]
      else
        (@hours += course.crmax) unless courses_before_add.include? params[:semcrn]
      end
    end
    total_credits = @cart.total_credits.to_f
    total_credits += @hours
    @cart.total_credits = total_credits
    @cart.update!(total_credits: total_credits)
    @cart.set_courses(courses)
    @cart_courses = Array.new
    if @cart.save
      @cart_courses = @cart.get_courses
    else
      @cart_courses = nil
    end
    @cart_courses
  end

  # remove a course from cart
  def remove
    @cart = Cart.find_by_cartid(params[:id])
    unless @cart.courses.blank?
      # put word boundaries around params[:semcrn]
      parts = @cart.courses.split(params[:semcrn])
      params[:cart] = {}
      params[:cart][:courses] = ""
      params[:cart][:courses] << parts[0].strip unless parts[0].blank?
      params[:cart][:courses] << " " + parts[1].strip unless parts[1].blank?
      @cart_courses = Array.new
      @hours = 0
      if @cart.update(cart_params)
        @cart_courses = @cart.get_courses
        course = Course.find_by_semcrn(params[:semcrn])
        if course.crmax != course.crmin
          @hours += course.crmin - course.crmax
        else
          @hours += course.crmax
        end
        total_credits = @cart.total_credits.to_f
        total_credits -= @hours
        if total_credits < 0
          total_credits = 0
        else
          @cart.total_credits = total_credits
        end
        @cart.update!(total_credits: total_credits)
      else
        @cart_courses = nil
        @cart.destroy
      end
    else
      @cart_courses = nil
    end
    @cart_courses
  end

  # clear cart of courses
  def clear
    @cart = Cart.find_by_cartid(params[:id])
    @cart.courses = nil
    @cart.total_credits = 0
    # if cookies[:cart] need to fix this... always tries to merge carts without this...
    #   cookies.delete :cart
    # end

    # if statements for dealing with a bug that displayed cart off-screen
    if cookies[:cartX]
      cookies.delete :cartX
    end
    if cookies[:cartY]
      cookies.delete :cartY
    end
    @cart.save!
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  # email cart
  def mail_to
    @cart = Cart.find_by_cartid(params[:id]).get_courses
    logger.debug @cart.inspect
    #if the user is signed in, use default e-mail address, or email address provided
    if !current_user.nil?
      @email = params[:email].blank? ? current_user.email : params[:email]
    else
      @email = params[:email]
    end
    @message = nil
    if verify_email @email
      @sender = current_user if current_user
      Interact.mail_cart(request.remote_ip, @cart, @email, @sender).deliver
      @message = "Email Sent"
    else
      @message = "Please use a valid email"
    end
  end

  def search
    if params[:value] == "notremote"
      return redirect_to root_path(value: params[:id])
    end
    @courses = Cart.find_by_cartid(params[:id]).get_courses
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render "courses/search" }
    end
  end

  private

  # Sets which params can be updated in the database from a call to update
  def cart_params
    params.require(:cart).permit(:total_credits, :courses)
  end

  def verify_email(email)
    (email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) == 0
  end
end
