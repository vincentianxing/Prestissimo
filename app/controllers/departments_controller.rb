class DepartmentsController < ApplicationController

  before_action :signed_in_user
  def index
    @depts = Department.all.to_a
  end

  def show
    @department = Department.find_by_dept(params[:id])
    return redirect_to error_404_path unless @department
    all_comments = @department.root_comments
    @comments = Array.new
    all_comments.each do |c|
      @comments << c unless c.status == "removed" || c.old
    end
    @comments = Comment.sort_by_score(@comments)
    respond_to do |format|
      format.html
      format.csv { render plain: @department.to_csv(params[:enroll]||=0) }
    end
  end

  private

  # check if there is a user
  def signed_in_user
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end
end
