class ApplicationController < ActionController::Base
  protect_from_forgery
  has_mobile_fu
  include SessionsHelper
  include UsersHelper
  
  before_action :mobile_switch

  def mobile_switch 
      if session[:mobile_view] == true && request.format.html?
	  request.format = :mobile
      elsif request.format.tablet?
	  request.format = :html
      end
  end
end
