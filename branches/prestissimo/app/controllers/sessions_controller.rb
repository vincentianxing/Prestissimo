class SessionsController < ApplicationController

  #If a non-ruby method is included, it is probably in the sessions helper file
  #or part of the BCrypt gem

  #Action associated with displaying an html form for creating a new session i.e. sign_up/sign_in
  def new
  end

  #Creates a new session
  def create
    email = params[:session][:email]
    if (email[/@oberlin\.edu$/] == nil && email != "oprestissimo@gmail.com")
      email = email+"@oberlin.edu"
    end
    @obie_email = email
    user = User.find_by_email(email)
    if user && user.authenticate(params[:session][:password])
      #If the user exists and gave the correct password, we sign him in and redirect him
      #to whatever page he was trying to get to (friendly forwarding)
      #check for a cart stored in a cookie
      if cookies[:cart]
	# need to merge the user's cart with the cookie one
	old_cart = Cart.find_by_cartid(cookies[:cart]).courses.split(' ')
	cart = user.cart.courses.clone
	old_cart.each do |semcrn|
	  cart << " #{semcrn}" unless cart.include? semcrn
	end
	user.cart.set_courses(cart)
	user.cart.save
	# delete the cookie cart
	Cart.find_by_cartid(cookies[:cart]).destroy
	cookies.delete :cart
      end
      sign_in user
      if session[:return_to] == signin_path
	redirect_to user
      else
	redirect_back_or user
      end
    else
      # error and re-render sign in
      flash[:failure] = 'Problem Signing In: Invalid email/password combination. Make sure email has flast@oberlin.edu format e.g. mkrislov@oberlin.edu.'
      @user = User.new 
      render 'users/new' 
    end
  end

  #End a session
  def destroy
    sign_out
    redirect_to root_path
  end

  #Hide or show the course search help box. This is a session action because we have
  #to 'remember' which choice the user last picked, show or hide.
  def click_hide_search
    toggle_box
    redirect_to hide_search_path
  end

  #Render the javascript that actually changes the visibility of the search help box
  def hide_search
    respond_to do |format|
      #	format.html
      format.js
    end
  end

  #Toggle mobile/html format layout
  def click_mobile_format
    if cookies[:mobile_format].nil?
      cookies.permanent[:mobile_format] = "true"
      session[:mobile_view] = true
    else
      cookies.delete(:mobile_format)
      session[:mobile_view] = false
    end
    redirect_to mobile_format_path
  end

  #Render javascript to change format
  def mobile_format
    redirect_back_or(root_path) 
  end

  def hide_motd
    # create cookie related to motd
    cookies.permanent[:motd] = DateTime.now.to_s
  end
end
