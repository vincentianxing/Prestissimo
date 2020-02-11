class HubcoursesController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: [:edit, :update, :destroy, :create, :new]

  def show
    @hubcourse = Hubcourse.find_by_hub_id(params[:id].gsub('-', ' '))
    return redirect_to error_404_path unless @hubcourse
    all_comments = @hubcourse.root_comments
    @comments = Array.new
    all_comments.each do |c|
	    @comments << c unless c.status == "removed" || c.old
    end
    @comments = Comment.sort_by_score(@comments)
    @courses = @hubcourse.courses.sort
    semcrns = Array.new()
    @courses.each do |c|
      semcrns << c.semcrn
    end
    for i in 0..semcrns.length-1
      if semcrns.count(semcrns[i]) > 1
	semcrns.delete_at(i);
	@courses.delete_at(i);
      end
    end
    @professors = Array.new
    @courses.each do |c|
      @professors.concat(c.professors)
    end
    @professors.uniq!
    @vals = {}
    @vals[:hubcourse] = @hubcourse
    @vals[:comments] = @comments
    @vals[:courses] = @courses
    @vals[:professors] = @professors
    respond_to do |format|
      format.html
      format.csv { render plain: @hubcourse.to_csv(params[:enroll]||=0) }
    end
  end

  def index
		@depts = Department.all.to_a
  end

  def search
    if !params[:dept].blank? || !(params[:comparator].blank? || params[:course_level].blank?)
      qs = ''
      qs = 'hub_id LIKE ' + ActiveRecord::Base.connection.quote("%"+params[:dept]+"%") + ' AND ' if !params[:dept].blank?
      if params[:comparator].blank? || params[:course_level].blank?
	5.times do
	  qs.chop!
	end
      else # both comparator and course_level have been set
	level = params[:course_level][0..2]
	if params[:comparator] == '='
	  above = level.to_i + 99
	  qs << 'cnum BETWEEN ' + ActiveRecord::Base.connection.quote(level)+' AND '+ActiveRecord::Base.connection.quote(above.to_s)
	else
	  if params[:comparator] == '<='
	    level = level.to_i + 99 
	  else
	    level = level.to_i
	  end
	  qs << 'cnum ' + params[:comparator] + ' ' + ActiveRecord::Base.connection.quote(level)
	end
      end
      @hubcourses = Hubcourse.where(qs).to_a
      @hubcourses = nil if @hubcourses.size == 0
    else
      @err_msg = "Please select an option from the drop-down before searching."
    end
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
