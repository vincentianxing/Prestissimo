class HandlesController < ApplicationController
  before_filter :signed_in_user
#  before_filter :correct_user, only: :update
  before_filter :admin_user, only: :mute
  
  def index
    @handle = current_handle
  end

  def search
    @handles
    if (params[:username].blank?)
      return nil unless params[:all]
      @handles = Handle.all
    else
      @handles = Handle.find(:all, conditions: "username LIKE '%#{params[:username]}%'")
    end
    @handles.delete(current_handle)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @handle = Handle.find_by_username(params[:username])
    all_comments = Comment.find_comments_by_user(@handle)
    @comments = Array.new
    all_comments.each do |c|
	    @comments << c unless c.status == "removed" || c.old
    end
    @vals = {}
    @vals[:handle] = @handle
    @vals[:comments] = @comments
    @vals
  end

  def update
    @handle = Handle.find(params[:id])
    if @handle.update_attributes( params[:handle] )
      flash[:success] = "Updated username"
    else
      flash[:failure] = "Username not valid or already taken"
    end
    redirect_to settings_path(current_user)
  end

  def mute
    @handle = Handle.find(params[:id])
    @handle.toggle(:is_mute)
    @handle.save
    @handle
  end

	def reveal
		@handle = Handle.find(params[:id])
		@admin = current_user
		@user
		User.all.each do |u|
			if u.handlekey == @handle.handlekey
				@user = u
			end
		end
		Interact.reveal_handle_user(@user, @admin, @handle).deliver
	end

  private
  
  def signed_in_user
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end

  def current_handle
    @handle = Handle.find_by_handlekey(current_user.handlekey)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
