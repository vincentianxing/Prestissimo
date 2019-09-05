class AdminsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user
  
  def admin
    
  end

  private
  
  def signed_in_user
    redirect_to signin_path, notice:"Please sign in." unless signed_in?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
