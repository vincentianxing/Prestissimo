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

  before_filter :signed_in_user
  before_filter :admin_user, only: [:populate, :edit, :update, :toggle_active, :new, :admin, :create]

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
    @professors = Professor.find(:all, conditions: "fname LIKE '%#{params[:name]}%' OR lname LIKE '%#{params[:name]}%'")
    respond_to do |format|
      format.html
      format.js
    end
  end

  # get the professor to be edited by the form
  def edit
    @professor = Professor.find(params[:id])
  end

  # change the professor according to the form
  def update
    @professor = Professor.find(params[:id])
    @professor.update_attributes(params[:professor])
    @professor
  end

  # switch a professor between active and dark
  def toggle_active
    @professor = Professor.find(params[:id])
    @professor.toggle_status
    @professor.save
    @professor
  end

  # render the professor page
  def show
    @professor = Professor.find(params[:id])
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
    @vals
  end
        
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

  private

  # check if their is a user
  def signed_in_user
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end

  # check that the user is an admin
  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end


end
