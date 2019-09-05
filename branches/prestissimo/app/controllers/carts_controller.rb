class CartsController < ApplicationController

  def create
    @cart = Cart.new
    courses = ""
    if params[:courses]
      params[:courses].each do |key,value|
	courses << ' ' + key.to_s unless courses.include? key.to_s
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
    @cart_courses
  end

  def destroy
    @cart = Cart.find_by_cartid(params[:id])
    cookies.delete :cart if cookies[:cart]
    @cart.destroy
  end

  def show
    @cart = Cart.find_by_cartid(params[:id])
    @cart_courses = cart.get_courses
  end

  # add the selected courses to the user's cart
  def update
    @cart = Cart.find_by_cartid(params[:id])
    if params[:courses]
      courses = @cart.courses.clone if @cart.courses
      params[:courses].each do |key,value|
	courses << ' '+key.to_s unless courses.include? key.to_s
      end
      courses.strip!
      @cart.set_courses(courses)
      @cart_courses = Array.new
      if @cart.save
	@cart_courses = @cart.get_courses
      else
	@cart_courses = nil
      end
      @cart_courses
    else
      @cart_courses = @cart.get_courses
    end
  end

  def add
    @cart = Cart.find_by_cartid(params[:id])
    courses = @cart.courses.clone if @cart.courses
    courses << ' '+params[:semcrn] unless courses.include? params[:semcrn]
    courses.strip!
    @cart.set_courses(courses)
    @cart_courses = Array.new
    if @cart.save
      @cart_courses = @cart.get_courses
    else
      @cart_courses = nil
    end
    @cart_courses
  end

  def remove
    @cart = Cart.find_by_cartid(params[:id])
    # put word boundaries around params[:semcrn]
    parts = @cart.courses.split(params[:semcrn])
    params[:cart] = {}
    params[:cart][:courses] = ""
    params[:cart][:courses] << parts[0].strip unless parts[0].blank?
    params[:cart][:courses] << ' ' + parts[1].strip unless parts[1].blank?
    @cart_courses = Array.new
    if @cart.update_attributes(params[:cart])
      @cart_courses = @cart.get_courses
    else
      @cart_courses = nil
    end
    @cart_courses
  end

  def mail_to
    @cart = Cart.find_by_cartid(params[:id]).get_courses
    logger.debug @cart.inspect
    @email = params[:email].blank? ? current_user.email : params[:email]
    @message  = nil
    if verify_email @email
      @sender = current_user if current_user
      Interact.mail_cart(request.remote_ip,@cart,@email,@sender).deliver
      @message = "Email Sent"
    else
      #@message = "Please use a valid email"
      @message = @email
    end
  end

  def search
    if params[:value] == 'notremote'
     redirect_to root_path(value: params[:id])
    else
      @courses = Cart.find_by_cartid(params[:id]).get_courses
      render 'courses/search'
    end
  end



  private

  def verify_email(email)
    (email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i) == 0
  end
end
