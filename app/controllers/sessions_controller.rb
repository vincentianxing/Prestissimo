=begin rdoc
 ==\Session Controller

 This is where we create sessions.

=end


class SessionsController < ApplicationController

  #If a non-ruby method is included, it is probably in the sessions helper file
  #or part of the BCrypt gem

=begin rdoc
  Action associated with displaying an html form for creating a new session i.e. sign_up/sign_in
=end
  def new
  end

=begin rdoc
  Creates a new session
=end
  def create
    email = params[:session][:email]
    if (email[/@oberlin\.edu$/]== nil)
      email = email+"@oberlin.edu"
    end
    @obie_email = email
    user = User.find_by_email(email)
    # create a new user if one doesn't already exist
    return redirect_to create_user_path(:user => params[:session].permit(:email, :password)) unless user
    result = authenticate(user.email.split('@')[0],params[:session][:password])
    if result
      #we get a list of results, but we only care about the first one
      result = result.first
      #If the user exists and gave the correct password, we sign them in and redirect them
      #to whatever page they was trying to get to (friendly forwarding)
      #check for a cart stored in a cookie
      if cookies[:cart] && !(Cart.find_by_cartid(cookies[:cart]).courses.nil?)
        if user.cart.courses.nil?
          old_cart = Cart.find_by_cartid(cookies[:cart]).courses.split(' ')
          cart = user.cart.courses
          old_cart.each do |semcrn|
            if cart.nil?
              cart = " #{semcrn}"
            else
              cart << " #{semcrn}" unless cart.include? semcrn
            end
          end
          user.cart.total_credits = Cart.find_by_cartid(cookies[:cart]).total_credits
        else
          # need to merge the user's cart with the cookie one
          old_cart = Cart.find_by_cartid(cookies[:cart]).courses.split(' ')
          cart = user.cart.courses.clone
          old_cart.each do |semcrn|
            cart << " #{semcrn}" unless cart.include? semcrn
          end
          total_credits = user.cart.total_credits
          total_credits ||= 0;
          total_credits += Cart.find_by_cartid(cookies[:cart]).total_credits
          user.cart.total_credits = total_credits
        end
        user.cart.set_courses(cart)
        #total_credits = Cart.find_by_cartid(cookies[:cart]).total_credits
        #user.cart.update(total_credits: total_credits)
        user.cart.save
        # clear the cookie cart, deleting is bad... keep cookie cart always for unsigned in cart activities...
        c_cart = Cart.find_by_cartid(cookies[:cart]) #cookie_cart
        c_cart.courses = nil
        c_cart.total_credits = 0
        c_cart.save!
        # if cookies[:cart] need to fix this... always tries to merge carts without this...
        #   cookies.delete :cart
        # end
        #cookies.delete :cart BAD
      end
      # Update the user's information based on the ldap
      user.fname = result.givenname.to_s.slice!(2..-3)
      user.lname = result.sn.to_s.slice!(2..-3)
      user.role = result.employeetype.to_s.slice!(2..-3)
      user.status = "active"
      
      if user.role == "Faculty" or user.role == "FACULTY"
        profId = Professor.find_by_userid(user.email.split("@")[0])
        if profId
          user.prof_id = profId.id
        else
          profId = Professor.where(fname: user.fname,  lname: user.lname)[0]
          if profId
            user.prof_id = profId.id
          end
        end
      end
        
      user.save
      sign_in user
      if session[:return_to] == signin_path
	redirect_to user_path(user.email.split('@')[0])
      else
	redirect_back_or user_path(user.email.split('@')[0])
      end
    else
      # error and re-render sign in
      flash[:failure] = 'Invalid email/password combination: Please use your <strong>ObieID</strong> (flast format) username and <strong>OCPass password</strong>.'
      @user = User.new 
      redirect_to signin_path 
    end
  end

=begin rdoc
  End a session
=end
  def destroy
    sign_out
    redirect_to root_path
  end

=begin rdoc
  Toggle mobile/html format layout
=end
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

=begin rdoc
  Render javascript to change format
=end
  def mobile_format
    redirect_back_or(root_path) 
  end

  def hide_motd
    # create cookie related to motd
    cookies.permanent[:motd] = DateTime.now.to_s
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def hide_disclaimer
    #create cookie related to disclaimer
    cookies.permanent[:disclaimer] = DateTime.now.to_s
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

end
