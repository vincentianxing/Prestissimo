class MyClassesController < ApplicationController
    #Want to display the users cart the same way it's displayed on the main page
  def show 
      @user = User.find(params[:id])
      @courses = @cart_courses = Cart.find(@user.cart_id).get_courses
  end

  def new
  end

  def index
  end

  def search
    if params[:value] == 'notremote'
     redirect_to root_path(value: params[:id])
    else
      @courses = Cart.find_by_cartid(params[:id]).get_courses
      render 'courses/search'
    end
  end

end
