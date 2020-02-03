require "spec_helper"

describe ProfessorsController do
  user = User.new
  professor = Professor.new(fname: "Bob", lname: "Geitz")
  professor.save
  #sign_in user

  it "should redirect when not logged in" do
    get :search, format: 'js'
    #get professor_search_path
    response.should redirect_to signin_path
  end

  describe "GET #search" do # TODO
    it "return nil if no query made" do
      get :search, name: nil, format: 'js'
      response.should be_nil
    end
    it "render the search page" do
      get :search, name: "Geitz, Bob", format: 'html'
      response.should render_template("search") # render problem
    end
  end

  describe "GET #edit" do
    it "get the professor to be edited by the form" do
      get :edit,
          fname: professor.fname, lname: professor.lname,
          format: 'html'
      assigns(:professor).should eq(professor)
    end
    pending "get the user who's name matches" do      
    end
  end

  describe "GET #update" do
    it "change the professor according to the form" do
      get :update, id: professor.id, professor: { professor => { nickname: "bob"} }
      professor.nickname.should eq("bob")
      should set_flash[:success]
      response.should redirect_to show_professor_path(fname: professor.fname, lname: professor.lname)
    end
  end

  describe "GET #toggle_active" do
    it "switch a professor's status" do
      professor.status = "dark"
      get :toggle_active,
          fname: professor.fname, lname: professor.lname,
          format: 'js'
      professor.status.should eq("active")
    end
  end

  describe "GET #show" do
    it "redirect to 404 if professor not found" do
      get :show,
          fname: professor.lname, lname: professor.fname
      response.should redirect_to error_404_path
    end
    it "render the professor page" do
      get :show,
          fname: professor.fname, lname: professor.lname,
          format: 'html'
      response.should render_template("show") # render problem
    end
  end

=begin WHAT IS "BOB GEITZ PROBLEM"?
  describe "GET #professor_courses" do
    it "generate all courses the professor can edit" do
      get :professor_courses,
          fname: professor.fname, lname: professor.lname,
          format: 'html'
    end
  end
=end
  # private
  #"#signed_in_user"
  #"#correct_professor_user"
  Professor.delete_all
end
