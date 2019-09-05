#A static page has no dynamic content, so each page is essentially just a view.

class StaticPagesController < ApplicationController
  def about
  end

  def help
  end

  def basics
  end

  def features
  end

  def questions
  end

  def questions_mailer
    @title = params[:title]
    @message = params[:message]
    @user = current_user
    Interact.send_q(@title, @message, @user).deliver
    redirect_to help_path
  end

  def guidelines
  end

  def advanced
  end
  
  def accounts
  end

  def cart
  end
end
