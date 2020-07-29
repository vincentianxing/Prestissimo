=begin rdoc
 ==\User Controller

 This is where we create User model objects in order to gather data from the database,
 manipulate it, and pass it back to the User views.

 *Permissions* for each action can be seen with the method signature.

=end

class UsersController < ApplicationController
  # need this to authenticate passwords
  #  include BCrypt
  include ApplicationHelper

=begin rdoc
  private method calls (at bottom of file) to limit the actions of certain users
  e.g., the destroy action only occurs if the user is an admin
=end
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :confirm_destroy, :self_destroy, :search]
  before_action :correct_user, only: [:edit, :update, :confirm_destroy, :self_destroy]
  before_action :admin_user, only: :destroy

=begin rdoc
  # Renders views/users/show.html.erb. This is the Profile page.
  #
  # *Permissions*: any browser
=end
  def show
    @user = User.find_by_email(params[:email] + '@oberlin.edu')
    return redirect_to error_404_path unless @user

    redirect_to show_professor_path(fname: @user.fname, lname: @user.lname) if faculty_user? @user

    # For schedule semester checking
    unless @user.cart.get_courses.empty?
      @semester = params[:sem] ? translate_semester(params[:sem]) : @user.cart.get_courses.min.semester
      @semester_long = expand_semester(@semester)
    end
  end

=begin rdoc
  # Posts changes to the user's settings.
  #
  # <tt>params[:user]</tt> is submitted by a call to
  # <tt>update_path(@user.id)</tt> i.e. in the file
  # views/users/edit.html.erb
  #
  # *Permissions* current_user
  #
=end
  def update
    @user = User.find(params[:id])

    # Make sure privacy_prefs isn't nil
    @user.privacy_prefs = '' if @user.privacy_prefs.nil?

    # Check to see if privacy_prefs have changed
    newprefs = ''
    newprefs << 'secondmajor' if params[:major] == '1'
    newprefs << ' nonickname' if params[:nickname] == '1'
    newprefs << ' noyear' if params[:year] == '1'
    newprefs << ' noinfo' if params[:info] == '1'
    newprefs << 'noschedule' if params[:schedule] == '1'
    newprefs.strip!
    params[:user][:privacy_prefs] = newprefs

    # update the user, there is no old_password field, so it needs to be removed from the hash
    if @user.update(params_user)
      flash[:success] = 'Settings successfully changed!'
      sign_in @user
      # go to the user profile
      redirect_to user_path(@user.email.split('@')[0])
      ahoy.track 'Update user settings'
    else # the user could not be saved (for some weird reason)
      redirect_to settings_path(@user.email.split('@')[0]), notice: 'Settings could not be changed. Please contact the Prestissmo managers!'
    end
  end

  # renders the edit view (settings)
  #
  # *Permissions* current_user
  def edit
    @user = User.find_by_email(params[:email] + '@oberlin.edu')
    redirect_to root_path unless @user
    redirect_to edit_professor_path(current_professor.fname, current_professor.lname) if faculty_user?(@user)
    @handle = Handle.find_by_handlekey(@user.handlekey)
    # the user and its handle are passed in a hash
    @vals = Hash[:user, @user, :handle, @handle]
  end

  # Posts a new user
  #
  # *Permissions* any browser
  def create
    # Sets up an object representing the LDAP db to connect to
    ldap = initialize_ldap_con
    # create a new user
    @obie_id = params[:user][:email]
    logger.debug params[:user][:email]
    return redirect_to error_404_path unless @obie_id

    # connect to the LDAP
    if ldap.bind
      # where to look in the ldap sorta
      treebase = 'ou=people,dc=ad,dc=oberlin,dc=edu'
      # find the user who's  uid is the one we want
      filter = Net::LDAP::Filter.eq('cn', (params[:user][:email].split('@')[0]).to_s)
      # search the ldap!
      result = ldap.search(base: treebase, filter: filter)
      if result.!empty?
        if authenticate(params[:user][:email].split('@')[0], params[:user][:password])
          params[:user].delete(:password)
          @user = User.new(params_user)
          # find the first LDAP entry for the given flast (we ignore any extra entries that also match, there should really not be any...)
          result = result.first
          @user.email = @user.email.split('@')[0] + '@oberlin.edu'
          # assign the parameters, chopping off leading and trailing quotes, brackets, and backslashes
          @user.fname = result.givenname.to_s.slice!(2..-3)
          @user.lname = result.sn.to_s.slice!(2..-3)
          @user.role = result.employeenumber.to_s.slice!(2..-3)
          @user.status = 'active'

          @user.create_cart

          # If user is faculty, match them to their id
          if @user.role == 'Faculty' || @user.role == 'FACULTY'
            # Find by ObieID
            prof_user = Professor.find_by_userid(@user.email.split('@')[0])
            if prof_user
              @user.prof_id = prof_user.id
            else
              # Find by first and last name
              prof_user = Professor.where(fname: @user.fname, lname: @user.lname)[0]
              @user.prof_id = prof_user.id if prof_user
            end
          end

          # save the user to the db
          if @user.save!
            flash[:success] = 'Welcome to OPrestissimo!'
            sign_in @user
            ahoy.authenticate(@user)
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
              @handle.username = get_adj(n) + 'Obie'
              ctr = 0
              while Handle.find_by_username(@handle.username) && ctr < 10
                n = prng.rand(1..5640)
                @handle.username = get_adj(n) + 'Obie'
                ctr += 1
              end
              # save the handle
              if @handle.save
                redirect_to guidelines_path
              else # the handle was not saved
                flash[:failure] = 'Something went wrong, contact the oprestissimo team'
                redirect_to user_path(@user.email.split('@')[0]) # they do not have a handle!
              end
            else
              redirect_to user_path(@user.email.split('@')[0])
            end
          else # the user could not be saved to the db
            flash[:failure] = 'Something went wrong, contact the oprestissimo team'
            redirect_to signin_path
          end
        else # user did not authenticate correctly, but was found in the ldap
          flash[:failure] = 'Invalid email/password combination: Please use your <strong>ObieID</strong> (flast format) username and <strong>OCPass password</strong>.'
          redirect_to signin_path
        end
      else # no user found in LDAP to match the flast given
        flash[:failure] = 'Please use your <strong>ObieID</strong> (flast format) username and <strong>OCPass password</strong>.'
        # session[:wrong_email_singup] = params[:user][:email]
        redirect_to signin_path
      end
    else # LDAP connection failure
      flash[:failure] = "There was a problem with Oberlin's LDAP server, please try again later."
      redirect_to signin_path
    end
  end

  # activates the user with the given nonce
  #
  # *Permissions* any browser
  # def activate
  #  # takes in a :nonce from the url (specified in routes)
  #  @user = User.find_by_nonce(params[:nonce])
  #  if @user
  #    # nonce_active? is in the user model, returns true if the user has a nonexpired nonce
  #    if @user.nonce_active?
  #      @user.status = 'active'
  #      # save the user as active
  #      if @user.save
  #        sign_in @user
  #        flash[:success] = "You have successfully activated your account"
  #        redirect_to user_path(@user.email.split('@')[0])
  #      else # the user could not be saved (not sure why)
  #        flash[:failure] = "Something went wrong"
  #        redirect_to user_path(@user.email.split('@')[0])
  #      end
  #    else # the nonce is expired and has been removed
  #      flash[:failure] = "Account activation code has expired. No account now exists with your email, so you may create a new account."
  #      @user.delete
  #      redirect_to signup_path
  #    end
  #  else # the given nonce is not in the database
  #    flash[:failure] = "Not a valid activation code, or your code has expired. If you cannot sign in to your account, it has been deleted and you must create a new one."
  #    redirect_to 'new'
  #  end
  # end

  # actions associated with the forgot password process

  # no specific user associated with password reset process
  #
  # *Permissions* any browser
  # def forgot_pass_page
  #  @user = User.new
  # end

  # sends a link to reset password of the account with the given email (if such an account exits)
  #
  # *Permissions* any browser
  # def send_forgot_mail
  #  @user = User.find_by_email(params[:email])
  #  @user ||= User.find_by_email(params[:email] + '@gmail.com')
  #  # if the user exists
  #  if @user
  #    # create a new unique token for the user
  #    @user.create_nonce
  #    if @user.save
  #      # send email with the activation code
  #      if Interact.reset_pass(@user).deliver
  #        flash[:success] = "A reset password email has been sent to #{@user.email}."
  #        redirect_to root_path
  #      else
  #        # email did not send
  #        flash[:failure] = "Something went wrong"
  #        redirect_to signin_path
  #      end
  #    else
  #      # user didn't save
  #      flash[:failure] = "Something went wrong"
  #      redirect_to signin_path
  #    end
  #  else # email is not associated with a user in the db
  #    flash[:failure] = "Not a user email"
  #    redirect_to signin_path
  #  end
  # end

  # loads the page if there is a user with passed nonce and it is nonexpired
  #
  # *Permissions* any browser
  # def edit_pass
  #  if @user = User.find_by_nonce(params[:nonce])
  #    # if the nonce is not expired
  #    if @user.nonce_active?
  #    else # nonce expired, cleaner has not removed
  #      flash[:failure] = "Password reset link expired"
  #      redirect_to signup_path
  #    end
  #  else # no nonce exists
  #    flash[:failure] = "Password reset link expired"
  #    redirect_to root_path
  #  end
  # end

  # submits a new password for the user
  #
  # *Permissions* any browser
  # def reset_pass
  #  # know the nonce is in the db and unexpired from the edit_pass method
  #  @user = User.find_by_nonce(params[:nonce])
  #  # save the new password to the user
  #  if @user.update( params[:user] )
  #    @user.nonce_complete
  #    flash[:success] = "Successfully reset password"
  #    # email confirmation of changed password
  #    Interact.change_pass(@user).deliver
  #    sign_in @user
  #    redirect_to user_path(@user.email.split('@')[0])
  #  else # the user could not be saved
  #    flash[:failure] = "Could not update password. Not sure why..."
  #    render 'edit_pass'
  #  end
  # end

  # renders the new view (signup)
  #
  # *Permissions* any browser
  def new
    @user = User.new
  end

  # render the page to delete account
  #
  # *Permissions* current_user
  def confirm_destroy
    @user = User.find_by_email(params[:email] + '@oberlin.edu')
    unless @user
      flash[:failure] = 'Could not find user by email'
      redirect_to root_path
    end
  end

  # used by a user to delete their own account (from confirm destroy page)
  #
  # *Permissions* current_user
  def self_destroy
    # get the user and its handle
    @user = User.find(params[:id])
    @handle = Handle.find_by_handlekey(@user.handlekey)
    # delete the handle and user
    @user.destroy
    @handle.mute
    @handle.save
    flash[:success] = 'Account deleted'
    redirect_to root_path
  end

  # The action used to delete a user. (for admin use)
  #
  # *Permissions* admin_user
  def destroy
    # get the user and its handle
    @user = User.find(params[:id])
    @handle = Handle.find_by_handlekey(@user.handlekey)
    # destroy the user and its handle
    @user.destroy
    @handle.mute.save
    flash[:success] = 'User destroyed'
    redirect_to users_path
  end

  # return all the users and render the user list page
  #
  # Permissions any user
  def index
    @users = User.all
  end

  # Actions related to the user search

  # search the users according to form from index page
  #
  # Permissions any user
  def search
    # build a query string
    usrqs = ''
    prfqs = ''
    handqs = ''
    # if :finduser has a value
    person = params[:person].strip
    if !(person.blank? || person.gsub(/\W+/, '').empty?)
      ##### USER SEARCH BIT #####
      # uses function defined in application helper to construct a mysql query string
      usrqs = make_query_string(person.gsub(/['"]/, ""), ["fname", "lname", "email"], false)
      usrqs << " AND role LIKE " + ActiveRecord::Base.connection.quote("%student%")
      @usrresults = []
      @usrresults = User.where(usrqs).to_a
      @usrresults.delete(current_user)
      @usrresults.sort_by! { |u| [u.lname, u.fname] }
      @usrresults = nil if @usrresults.empty?

      ##### COMMENTER SEARCH BIT #####
      # uses function defined in application helper to construct a mysql query string
      handqs = make_query_string(person, ['username'], false)
      @handleresults = Handle.where(handqs).to_a
      @handleresults.delete(Handle.find_by_handlekey(current_user.handlekey))
      @handleresults.sort_by! { |h| h.username }
      @handleresults = nil if @handleresults.empty?

      ##### PROF PAGE SEARCH BIT #####
      # uses function defined in application helper to construct a mysql query string
      prfqs = make_query_string(person.gsub(/['"]/, ""), ["fname", "lname", "nickname"], false)
      @professors = Professor.where(prfqs).to_a
      @professors.sort_by! { |p| [p.lname, p.fname] }
      @professors = nil if @professors.empty?
    else # :finduser does not have a value
      @err_msg = 'You must enter at least one letter or number to seach for.'
    end
    # perform the search query, remove the current user from results
    # format to js and html
    respond_to do |format|
      format.mobile
      format.html
      format.js
    end
  end

  def schedule
    @user = User.find_by_email(params[:email] + '@oberlin.edu')
    return redirect_to root_path unless @user

    unless @user.cart.get_courses.empty?
      @semester = params[:sem] ? translate_semester(params[:sem]) : @user.cart.get_courses.min.semester
      @semester_long = expand_semester(@semester)
    end
    ahoy.track 'View schedule'
  end

  private

  # Set which params can be updated by update
  def params_user
    params[:user].permit(:second_major, :major, :email, :fname,
                         :nickname, :year, :notes, :privacy_prefs)
  end

  # verify that there is a signed in user, uses sessions_helper method signed_in?
  def signed_in_user
    # send away the user unless signed in
    redirect_to signin_path, notice: 'Please sign in.' unless signed_in?
  end

  # send away the user unless the action they've directed to is on their own account
  def correct_user
    begin
      # try finding the user by their obie id
      @user = User.find_by_email!(params[:email] + '@oberlin.edu')
    rescue
      # if that doesn't work, try finding the user by their id number
      @user = User.find(params[:id])
    end
    # use current_user? from sessions helper
    redirect_to(root_path) unless current_user?(@user)
  end

  # send away the user unless it is an admin
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def get_adj(n)
    f = File.open("#{Rails.root}/app/assets/adjectives", 'r')
    if f
      n.times { f.gets }
      adj = (p $_).chop!
      adj
    end
  end

  def translate_semester(semester)
    return '' if semester.nil?

    sem = semester.split(' ')
    ret = 'f' if sem[0] == 'Fall'
    ret = 's' if sem[0] == 'Spring'
    ret = 'u' if sem[0] == 'Summer'
    ret << sem[1][2..3]
  end

  def expand_semester(semester)
    s = 'Fall' if semester[0] == 'f'
    s = 'Spring' if semester[0] == 's'
    s = 'Summer' if semester[0] == 'u'
    s << " 20#{semester[1..2]}"
  end
end
