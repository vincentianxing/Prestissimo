require 'spec_helper'

describe ProfessorsController do
  professor = PRofessor.create

  describe "should redirect when not logged in" do
    # get :search, format: 'js'
    get professor_search_path
    response.should redirect_to signin_path
  end

  describe "GET #search" do
    get :search, format: 'js'
  end

  describe "GET #edit" do
    get :edit, 
        fname: professor.fname, lname: professor.lname,
        format: 'html'
  end

  describe "GET #update" do
    get :update, params: professor.id
  end
  
  describe "GET #toggle_active" do
    get :toggle_active, 
        fname: professor.fname, lname: professor.lname,
        format: 'js'
  end
  
  describe "GET #show" do
    get :show,
        fname: professor.fname, lname: professor.lname,
        format: 'html'
  end
  
  describe "GET #professor_courses" do
    get :professor_courses,
        fname: professor.fname, lname: professor.lname,
        format: 'html'
  end

  # private
  #"#signed_in_user"
  #"#correct_professor_user"

end
