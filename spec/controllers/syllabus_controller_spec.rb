require 'spec_helper'

describe SyllabusController do

  describe "GET #new" do
    course_arr = ["Computer Science", "CSCI", "214", "01", 
                    "532", "Full Term", "", "202009",
                    "", "Principles of Computer Science", 
                    "Geitz, Bob"]
    context "when course has no syllabus" do
      it "should make a new syllabus" do
        course = Course.build(course_arr)
        course.save
        course.syllabus = nil
        expect{ get :new, id: course.id }.to change{ Syllabus.count }.by(1)
      end
    end
    context "when course has a syllabus" do
      it "should @syllabus to the syllabus" do
        course = Course.build(course_arr)
        course.save
        course.syllabus = Syllabus.create
        get :new, id: course.id
        assigns(:syllabus).should eq(course.syllabus)
      end
    end

  end

  describe "GET #show" do
    it "should redirect to the syllabus" do
      path = 'http://132.162.201.242/app/doc/README_FOR_APP.html'
      syllabus = Syllabus.new(path: path)
      syllabus.save
      get :show, id: syllabus.id
      response.should redirect_to path
    end
  end

  describe "POST #create" do
    it "should flash" do # cannot test no flash when path invalid, due to the structure
      path =  'http://132.162.201.242/app/doc/README_FOR_APP.html'
      syllabus = Syllabus.new(path: path)
      syllabus.save
      post :create, id: syllabus.id, syllabus: { path: path }
      should set_flash[:success]
    end
  end

end
