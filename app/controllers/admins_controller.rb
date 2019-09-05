class AdminsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user
  
  def admin
    
  end

  def expire_sessions
    User.all.each do |user|
      # before users are saved they get new remember_tokens so sessions will expire
      user.save unless user.admin?
    end
    redirect_to admin_page_path
  end

  private
  
  def signed_in_user
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
