class SyllabusController < ApplicationController
  def new
    @course = Course.find(params[:id])
    if @course.syllabus == nil
      @syllabus = Syllabus.new
      @course.syllabus = @syllabus
      @syllabus.save
    else
      @syllabus = @course.syllabus
    end
  end

  def show
    @syllabus = Syllabus.find(params[:id])
    redirect_to @syllabus.path
  end

  def create
    @syllabus = Syllabus.find(params[:id])
    @syllabus.path = params[:syllabus][:path] # passes syllabus as an argument    
    # should check to make sure the path is valid
    if @syllabus.save
      flash[:success] = "You have successfully uploaded the syllabus!"
    end
    redirect_to @syllabus.path
  end

end
