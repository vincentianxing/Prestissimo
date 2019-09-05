#############################################################################
###
###  User Controller
###
###  These actions perform operations related to the user object
###  
###  ACTIONS in the order they appear on the page:
###
###  ACTION  ________________ PERMISSIONS
###  show   _________________ any browser
###  update _________________ current_user
###  edit   _________________ current_user
###  create _________________ any browser
###  activate _______________ any browser
###  forgot_pass_page _______ any browser
###  send_forgot_mail _______ any browser
###  edit_pass ______________ any browser (the user doesn't know how to sign in!)
###  reset_pass _____________ any browser
###  new ____________________ any browser
###  confirm_destroy ________ current_user
###  self_destroy ___________ current_user
###  destroy ________________ admin_user
###  index __________________ any user
###  search _________________ any user
###
###


class UsersController < ApplicationController
  # need this to authenticate passwords
  include BCrypt

  # private method calls (at bottom of file) to limit the actions of certain users
  # e.g., the destroy action only occurs if the user is an admin
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy, :confirm_destroy, :self_destroy, :search]
  before_filter :correct_user, only: [:edit, :update, :confirm_destroy, :self_destroy]
  before_filter :admin_user, only: :destroy

  # renders the show view (Profile page)
  def show
    @user = User.find(params[:id])
  end

  # Posts changes to the user's info
  # params[:user] is submitted by a form on the /settings page
  def update
    @user = User.find(params[:id])
    # First check user's old password to validate
    if (@user.authenticate(params[:user][:old_password]) != false)
      # Try to update attributes (except old_password, which doesn't exist as a db field)
      password_changed = false
      password_changed = true if !params[:user][:password].empty? && Password.new(@user.password_digest) != params[:user][:password]

      # Make sure privacy_prefs isn't nil
      if @user.privacy_prefs.nil?
	@user.privacy_prefs = ""
      end

      # Check to see if privacy_prefs have changed
      newprefs = ""
      if params[:gender] == '1'
	newprefs << "nogender"
      end
      if params[:nickname] == '1'
	newprefs << " nonickname"
      end
      if params[:year] == '1'
	newprefs << " noyear"
      end
      if params[:info] == '1'
	newprefs << " noinfo"
      end
      newprefs.strip!
      params[:user][:privacy_prefs] = newprefs

      # update the user, there is no old_password field, so it needs to be removed from the hash
      if @user.update_attributes( params[:user].delete_if{ |key,value| key == "old_password" } )
	flash[:success] = "Settings successfully changed!"
	# send an email alerting a password change
	Interact.change_pass(@user).deliver if password_changed
	sign_in @user
	# go to the user profile
	redirect_to @user
      elsif params[:user][:password].length < 6
	redirect_to settings_path, :notice => "Please make sure your new password is at least 6 characters long. If it still does not work, please contact a Prestissimo Manager!"
      else # the user could not be saved (for some weird reason)
	redirect_to settings_path, :notice => "Settings could not be changed. Please contact the Prestissmo managers!"
      end
    else # old_password does not match the password associated with the user
      if (params[:user][:old_password].empty?)
	redirect_to settings_path, :notice => "Please enter your current password at the bottom of the page."
      else
	redirect_to settings_path, :notice => "The password you entered as your current password does not match our records. Please try again!"
      end
    end
  end

  # renders the edit view (settings)
  def edit
    @user = User.find(params[:id])
    @handle = Handle.find_by_handlekey(@user.handlekey)
    # the user and its handle are passed in a hash
    @vals = Hash[:user,@user,:handle,@handle]
  end

  #Posts a new user
  def create
    # Sets up an object representing the LDAP db to connect to
    ldap = Net::LDAP.new(port: 389, host: 'ldap1.cc.oberlin.edu')
    # create a new user
    @obie_id = params[:user][:email]
    logger.debug params[:user][:email]
    @user = User.new(params[:user])
    # connect to the LDAP
    if ldap.bind

      # makes sure the 'sn' field has a value for all the returned results
      filter = Net::LDAP::Filter.present("sn")
      # returns results where the uid is the email (passed as the person's flast from the signup form)
      treebase = "uid=#{@user.email},ou=people,o=oberlin.edu,o=oberlin-college"
      # check that there is an LDAP entry for the given flast
      if (ldap.search(:base => treebase, :filter => filter, :return_result => false))
	@user.email = @user.email + "@oberlin.edu"
	# perform the search
	ldap.search(:base => treebase, :filter => filter) do |entry|
	  # assign the parameters, chopping off leading and trailing quotes, brackets, and backslashes
	  @user.fname = entry.givenname.to_s.slice!(2..-3)
	  @user.lname = entry.sn.to_s.slice!(2..-3)
	  @user.role = entry.o.to_s.slice!(2..-3)
	end

	# save the user to the db
	if @user.save
	  flash[:success] = "Welcome to OPrestissimo! An email has been sent to you. Please follow the instructions to activate your account within the next 24 hours."
	  # send the authentication email
	  Interact.activate(@user).deliver
	  sign_in @user
	  # check for existing handle
	  @handle = Handle.find_by_handlekey(@user.handlekey)
	  # create the handle if there isn't one
	  if @handle.nil?
	    @handle = Handle.new
	    # calls the handlekey generation method in the user model and assigns the result to the handle
	    @handle.handlekey = @user.handlekey
	    logger.debug @handle.handlekey

	    # initially has no username
	    prng = Random.new
	    n = prng.rand(1..5640)
	    @handle.username = get_adj(n)+"Obie"
	    ctr = 0
	    while (Handle.find_by_username(@handle.username) && ctr < 10) do
	      n = prng.rand(1..5640)
	      @handle.username = get_adj(n)+"Obie"
	      ctr += 1
	    end
	    # save the handle
	    if @handle.save
	      redirect_to guidelines_path
	    else # the handle was not saved
	      flash[:failure] = "Something went wrong, contact the oprestissimo team"
	      redirect_to @user # they do not have a handle!
	    end
	  else
	    redirect_to @user
	  end

	else # the user could not be saved to the db
	  if (!params[:user][:password].nil? && params[:user][:password].length >= 6)
	    flash.now[:failure] = "It looks like you already have registered an account! Please sign in or contact us for help."
	  end
	  render 'new'
	end
      else # no user found in LDAP to match the flast given
	flash.now[:failure] = "Please use your Oberlin ID (flast format) and make sure your passwords match."
	#session[:wrong_email_singup] = params[:user][:email]
	render 'new'
      end
    end
  end

  # activates the user with the given nonce
  def activate
    # takes in a :nonce from the url (specified in routes)
    @user = User.find_by_nonce(params[:nonce])
    if @user
      # nonce_active? is in the user model, returns true if the user has a nonexpired nonce
      if @user.nonce_active?
	@user.status = 'active'
	# save the user as active
	if @user.save
	  sign_in @user
	  flash[:success] = "You have successfully activated your account"
	  redirect_to @user
	else # the user could not be saved (not sure why)
	  flash[:failure] = "Something went wrong"
	  redirect_to @user
	end
      else # the nonce is expired and has been removed
	flash[:failure] = "Account activation code has expired. No account now exists with your email, so you may create a new account."
	@user.delete
	redirect_to signup_path
      end
    else # the given nonce is not in the database
      flash[:failure] = "Not a valid activation code, or your code has expired. If you cannot sign in to your account, it has been deleted and you must create a new one."
      redirect_to 'new'
    end
  end

  # actions associated with the forgot password process

  # no specific user associated with password reset process
  def forgot_pass_page
    @user = User.new
  end

  # sends a link to reset password of the account with the given email (if such an account exits)
  def send_forgot_mail
    @user = User.find_by_email(params[:email])
    # if the user exists
    if @user
      # create a new unique token for the user
      @user.create_nonce
      if @user.save
	# send email with the activation code
	if Interact.reset_pass(@user).deliver
	  flash[:success] = "A reset password email has been sent to #{@user.email}."
	  redirect_to root_path
	else
	  # email did not send
	  flash[:failure] = "Something went wrong"
	  redirect_to signin_path
	end
      else
	# user didn't save
	flash[:failure] = "Something went wrong"
	redirect_to signin_path
      end
    else # email is not associated with a user in the db
      flash[:failure] = "Not a user email"
      redirect_to signin_path
    end
  end

  # loads the page if there is a user with passed nonce and it is nonexpired
  def edit_pass
    if @user = User.find_by_nonce(params[:nonce])
      # if the nonce is not expired
      if @user.nonce_active?
      else # nonce expired, cleaner has not removed
	flash[:failure] = "Password reset link expired"
	redirect_to signup_path
      end
    else # no nonce exists
      flash[:failure] = "Password reset link expired"
      redirect_to root_path
    end
  end

  # submits a new password for the user
  def reset_pass
    # know the nonce is in the db and unexpired from the edit_pass method
    @user = User.find_by_nonce(params[:nonce])
    # save the new password to the user
    if @user.update_attributes( params[:user] )
      @user.nonce_complete
      flash[:success] = "Successfully reset password"
      # email confirmation of changed password
      Interact.change_pass(@user).deliver
      sign_in @user
      redirect_to @user
    else # the user could not be saved
      flash.now[:failure] = "Could not update password. Not sure why..."
      render 'edit_pass'
    end
  end


  #renders the new view (signup)
  def new
    @user = User.new
  end

  # render the page to delete account
  def confirm_destroy
    @user = User.find(params[:id])
  end

  # used by a user to delete their own account (from confirm destroy page)
  def self_destroy
    # get the user and its handle
    @user = User.find(params[:id])
    @handle = Handle.find_by_handlekey(@user.handlekey)
    # authenticate password to delete
    if (@user.authenticate(params[:password]) != false)
      # delete the handle and user
      @user.destroy
      @handle.mute
      @handle.save
      flash[:success] = "Account deleted"
      redirect_to root_path
    else # the password was incorrect
      flash[:failure] = "Incorrect user password"
      redirect_to confirm_destroy_path(@user.id)
    end
  end

  # The action used to delete a user. (for admin use)
  def destroy
    # get the user and its handle
    @user = User.find(params[:id])
    @handle = Handle.find_by_handlekey(@user.handlekey)
    # destroy the user and its handle
    @user.destroy
    @handle.mute.save
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  # return all the users and render the user list page
  def index
    @users = User.all
  end

  # Actions related to the user search

  # search the users according to form from index page
  def search
    # build a query string
    usrqs = ''
    # if :finduser has a value
    person = params[:person]
    if !(person.blank? || person.length < 3)
      ##### USER SEARCH BIT #####
      # search by fname, lname, and email for the name
      usrqs = '(fname LIKE '+ActiveRecord::Base.connection.quote("%"+person+"%")+' OR lname LIKE '+ActiveRecord::Base.connection.quote("%"+person+"%")+' OR email LIKE '+ActiveRecord::Base.connection.quote("%"+person+"%")+')'
      @usrresults = Array.new
      @usrresults = User.find(:all, :conditions => usrqs)
      @usrresults.delete(current_user)
      @usrresults = nil if @usrresults.size == 0

      ##### COMMENTER SEARCH BIT #####
      @handleresults = Handle.find(:all, conditions: "username LIKE '%#{person}%'")
      @handleresults.delete(Handle.find_by_handlekey(current_user.handlekey))
      @handleresults = nil if @handleresults.size == 0

      ##### PROF PAGE SEARCH BIT #####
      @professors = Professor.find(:all, conditions: "fname LIKE '%#{person}%' OR lname LIKE '%#{person}%'")
      @professors = nil if @professors.size == 0

    else # :finduser does not have a value
      @err_msg = "Please enter a search query that is at least 3 characters long to perform a search!"
    end
    # perform the search query, remove the current user from results
    # format to js and html
    respond_to do |format|
      format.mobile
      format.html
      format.js
    end
  end


  private

  # verify that there is a signed in user, uses sessions_helper method signed_in?
  def signed_in_user
    # send away the user unless signed in
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end

  # send away the user unless the action they've directed to is on their own account
  def correct_user
    @user = User.find(params[:id])
    # use current_user? from sessions helper
    redirect_to(root_path) unless current_user?(@user)
  end

  # send away the user unless it is an admin
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def get_adj(n)
    f = File.open("#{Rails.root}/app/assets/adjectives", 'r')
    if (f)
      n.times { f.gets }
      adj = ( p $_ ).chop!
      adj
    else
      nil
    end
  end
end
