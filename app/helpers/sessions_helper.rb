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

  #Check if a given user's role is 'Faculty'
  def faculty_user?(user)
    user.role.downcase == 'faculty'
  end

  #Sets the current professor using the current user's fname and lname.
  def current_professor
    @current_professor ||= Professor.find_by_id(current_user.prof_id)
    @current_professor ||= Professor.where(userid: current_user.email.split('@')[0])[0]
    @current_professor ||= Professor.where(fname: current_user.fname, lname: current_user.lname)[0]
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

  def motd
    @motd ||= Setting.find_by_key('motd')
  end

  def disclaimer
    @disclaimer ||= Setting.find_by_key('disclaimer')
  end

  def motd_cookie_expired?
    begin
      if DateTime.parse(cookies[:motd]) < motd.updated_at
        cookies.delete :motd
        return true
      else
        return false
      end
    rescue ArgumentError
      cookies.delete :motd
      return true
    end
  end

# something isn't working right (the updated_at)
  def disclaimer_cookie_expired?
    if DateTime.parse(cookies[:disclaimer]) < disclaimer.updated_at
      cookies.delete :disclaimer
      return true
    else
      return false
    end
  end

  #initialize a connection to the college ldap, and return an object representing it
  def initialize_ldap_con
    credentials = {
      :method => :simple,
      :username => "cn=pr-oprest,ou=dmanage,o=oberlin.edu,o=oberlin-college",
      :password => "OC-2015op"
    }
    Net::LDAP.new(
      :host => "ldap.oberlin.edu",
      :port => "636",
      :encryption => :simple_tls,
      :base => "ou=People,o=oberlin.edu,o=Oberlin-College",
      :auth => credentials
    )
  end

  #Authenticate a user against the college ldap
  #returns false on failure and an array of matching ldap entries on success
  def authenticate(user, pass)
    ldap = initialize_ldap_con
    return false unless ldap.bind

    result = ldap.bind_as(
      :filter => "(uid=#{user})",
      :password => pass
    )
  end
end
