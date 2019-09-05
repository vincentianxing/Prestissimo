class DepartmentsController < ApplicationController

  before_filter :signed_in_user
	def index
		@depts = Department.find(:all)
	end

	def show
		@department = Department.find(params[:id])
		all_comments = @department.root_comments
		@comments = Array.new
		all_comments.each do |c|
			@comments << c unless c.status == "removed" || c.old
		end
		@comments = Comment.sort_by_score(@comments)
	end

  private

  # check if there is a user
  def signed_in_user
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end
end
