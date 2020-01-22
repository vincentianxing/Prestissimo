require 'spec_helper'

describe SyllabusController do

  describe "GET syllabus#new" do
    context "when course has no syllabus" do
      it "should make a new syllabus" do
        course = Course.create
        course.syllabus = nil
        expect{ get :new, id: course.id }.to change{ Syllabus.count }.by(1)
      end
    end
    context "when course has a syllabus" do
      it "should @syllabus to the syllabus" do
        course = Course.create
        course.syllabus = Syllabus.create
        get :new, id: course.id
        assigns(:syllabus).should eq(course.syllabus)
      end
    end

  end

  describe "GET syllabus#show" do
    it "should redirect to the syllabus" do
      path = 'http://132.162.201.242/app/doc/README_FOR_APP.html'
      syllabus = Syllabus.new(path: path)
      syllabus.save
      get :show, id: syllabus.id
      response.should redirect_to path
    end
  end

  describe "POST syllabus#create" do
    it "should flash" do
      syllabus = Syllabus.new
      syllabus.save
      post :create, id: syllabus.id
      expect{flash[:success]}.should_not exist
    end
  end

end
