module SessionsHelper

  #Sign in a user with a cookie
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  #Checks if the user is signed in
  def signed_in?
    !current_user.nil?
  end

  #Allows us to set the current user
  def current_user=(user)
    @current_user = user
  end

  #Sets the current user, if not already set, by using the remember_token cookie
  #we set when the user signed in
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  #Check if a given user is equivalent to the current user signed in
  def current_user?(user)
    user == current_user
  end

  #Sign out the current user
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  #Permits friendly forwarding i.e. if a user tries to go to a page that requires a sign in,
  #he'll be redirected to that page after signing in if possible
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  #Remembers the url of the page the user tried to visit
  def store_location
    session[:return_to] = request.fullpath
  end

  #Sets a cookie to remember if the user wants to show or hide the search help box
  def toggle_box
    if cookies[:hide_search].nil?
      cookies.permanent[:hide_search] = "Hide"
    else
      cookies.delete(:hide_search)
    end
  end

  def motd
    @motd ||= Setting.find_by_key('motd')
  end

  def motd_cookie_expired?
    if DateTime.parse(cookies[:motd]) < motd.updated_at
      cookies.delete :motd
      return true
    else
      return false
    end
  end
end
