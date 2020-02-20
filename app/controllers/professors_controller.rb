#############################################################################
###
###  Professor Controller
###
###  These actions perform operations related to the professor object
###  
###  ACTIONS in the order they appear on the page:
###
###  ACTION  ________________ PERMISSIONS
###  new    _________________ admin
###  create _________________ admin
###  index __________________ any user
###  search _________________ any user
###  edit ___________________ admin
###  update _________________ admin
###  toggle_active __________ admin
###  show ___________________ any user
###  populate _______________ admin
###

class ProfessorsController < ApplicationController

  before_action :signed_in_user
  before_action :correct_professor_user, only: [:edit, :update, :professor_courses] 
  before_action :admin_user, only: [:populate, :toggle_active, :new, :admin, :create]

  # render the page with the form for a new professor
  def new
  end

  # create a new professor from form
  def create
  end

  # render the page with the professor search
  def index
  end

  def search
    # return nothing if no query made
    return nil if params[:name].blank?
    # search by both first name and last name
    @professors = Professor.where("fname LIKE '%#{params[:name]}%' OR lname LIKE '%#{params[:name]}%'").to_a
    respond_to do |format|
      format.html
      format.js
    end
  end

  # get the professor to be edited by the form
  def edit
    @professor = Professor.where(fname: params[:fname], lname: params[:lname])[0]

    if @professor.nil?
      # Find the user who's name matches
      @prof_user = User.where(fname: params[:fname], lname: params[:lname])[0]
      unless @prof_user.nil?
        # Try to fond the professor based on the user's other info
        @professor ||= Professor.find_by_id(@prof_user.prof_id)
        @professor ||= Professor.where(userid: @prof_user.email.split('@')[0])[0]
      end
    end

    return redirect_to nameerror_path if @professor.blank?
    @professor
  end

  # change the professor according to the form
  def update
    @professor = Professor.find(params[:id])

    if @professor.update(params_professor)
      flash[:success] = "Profile successfully updated!"
      # go to the professor profile
      redirect_to show_professor_path(fname: @professor.fname, lname: @professor.lname)
    else # the professor could not be saved (for some reason)
      redirect_to edit_professor_path(fname: @professor.fname, lname: @professor.lname), :notice => "Settings could not be changed. Please contact the Prestissmo managers!"
    end
  end

  # switch a professor between active and dark
  def toggle_active
    @professor = Professor.where(fname: params[:fname], lname: params[:lname])[0]
    @professor.toggle_status
    @professor.save
    @professor
  end

  # render the professor page
  def show
    @professor = Professor.where(fname: params[:fname], lname: params[:lname])[0]
    return redirect_to error_404_path unless @professor
    all_comments = @professor.root_comments
    @comments = Array.new
    all_comments.each do |c|
        @comments << c unless c.status == "removed" || c.old
    end
    @comments = Comment.sort_by_score(@comments)
    # build a hash to return the professor and its comments
    @vals = {}
    @vals[:professor] = @professor
    @vals[:comments] = @comments
    
    @hubcourses = Hash.new
    prev_semcrn = -1
    prof_all_courses = @professor.courses.sort
    prof_all_courses.each do |course|
      next if course.semcrn == prev_semcrn
      prev_semcrn = course.semcrn
      @hubcourses[course.hubcourse] ||= [] unless course.status=="hidden" || course.status=="cancelled"
      @hubcourses[course.hubcourse] << course unless course.status=="hidden" || course.status=="cancelled"
    end

    @vals[:hubcourses] = @hubcourses

    @vals
    respond_to do |format|
      format.html
      format.csv { render plain: @professor.to_csv(params[:enroll]||=0) }
    end
  end
        
  # Unused. Also, don't use this. It's out of date.
  # The LDAP connection shit is super different now.
  # Also, if you used this it wouldn't connect the
  # professors to courses or departments.
  def populate
    # LDAP TIME!
    ldap = Net::LDAP.new( port: 389, host: 'ldap1.cc.oberlin.edu' )
    @names = Array.new
    if ldap.bind
      # query for role=Faculty
      filter = Net::LDAP::Filter.eq("o","Faculty")
      treebase = "ou=People,o=oberlin.edu,o=oberlin-college"
      @professors = Array.new
      ldap.search(base: treebase, filter: filter) do |results|
        @professors << results
      end
      @professors.each do |p|
        # need to take out leading and trailing slashes, brackets, and quotes
        mail = p.mail.to_s.slice(2..-3)
        if (Professor.find_by_email(mail) == nil)
          prof = Professor.new
          prof.lname = p.sn.to_s.slice(2..-3)
          # some professors share names with students, and have Faculty in their lname
          prof.lname.gsub!('Faculty','') if (prof.lname.include? 'Faculty')
          prof.fname = p.givenname.to_s.slice(2..-3)
          prof.nickname = ''
          prof.email = mail
          if prof.save
            @names << prof.fname + " " + prof.lname
          end
        end
      end
    end
    # array of the new professors
    @names
  end

  # Function to generate a preview of a professor's more information content.
  # Uses the redcarpet gem to render markdown formatted input as html.
  def preview
   # @professor = Professor.where(fname: params[:fname], lname: params[:lname])[0]
   # @result = ""
   # @result ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, underline: true, highlight: true, lax_spacing: true).render(params[:professor][:content])
   # @result.html_safe
    respond_to do |format|
      format.js
    end
  end

  #Function to generate all the courses the professor has the permission to edit
  def professor_courses
    @professor = Professor.where(fname: params[:fname], lname: params[:lname])[0]
    
    # Fix for the "Bob Geitz problem" where the user's name is different from the professor's
    if @professor.nil?
      # Find the user who's name matches
      @prof_user = User.where(fname: params[:fname], lname: params[:lname])[0]
      unless @prof_user.nil?
        # Try to fond the professor based on the user's other info
        @professor ||= Professor.find_by_id(@prof_user.prof_id)
        @professor ||= Professor.where(userid: @prof_user.email.split('@')[0])[0]
      end
    end

    #Redirects to the nameerror file with a text field to allow professors to let us know their accounts aren't connected
    return redirect_to nameerror_path if @professor.blank?

    @prof_cart = current_user.cart.get_courses
    @prof_courses = Hash.new
    short_cur_sem = view_context.current_semester[0].downcase+view_context.current_semester[-2..-1]
    
    @prof_courses["teaching"]=@professor.courses.delete_if{|x| x.semester!=short_cur_sem}
    @prof_courses["requests"] = @prof_cart unless @prof_cart.length==0
    
    @professor.departments.each do |d|
      qs  = '( dept LIKE '+ActiveRecord::Base.connection.quote("%"+d.dept+"%")+" AND semester=" + ActiveRecord::Base.connection.quote(short_cur_sem) + ")"
      dept_courses = Course.where(qs).sort
      @prof_courses[d.dept] = dept_courses if dept_courses.size > 0
    end
    
  end


  private

  # Set which params can be updated with update
  def params_professor
    params[:professor].permit(:fname, :lname, :email, :nickname, :contact, :phone, :office, :content, :url)
  end

  # check if there is a user
  def signed_in_user
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end

  # check that the user is an admin
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def correct_professor_user
    begin
      prof_temp = Professor.find(params[:id]) 
      @prof_user = User.where(fname: prof_temp.fname, lname: prof_temp.lname)[0]
    rescue
      @prof_user = User.where(fname: params[:fname], lname: params[:lname])[0]
    end
    redirect_to(root_path) unless current_user?(@prof_user) && faculty_user?(current_user)
  end

end
