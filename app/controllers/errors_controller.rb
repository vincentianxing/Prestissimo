class ErrorsController < ApplicationController
  layout false

  # renders 404 error page
  def not_found
    render :file => "errors/404", :status => 404, :formats => [:html]
  end

  # renders 500 error page
  def server_error
    unless get_exception.nil?
      e = get_exception
      @message = "#{e.class} (#{e.message})\n\t#{Rails.backtrace_cleaner.clean(e.backtrace).join("\n\t")}" #more info that could be useful, but can be quite verbose# \nRequest was a #{request.method}.\n\nRequest_parameters() :\n\t#{request.request_parameters}\n\nQuery_parameters() :\n\t#{request.query_parameters}\n\nPath_parameters() :\n\t#{request.path_parameters}\n\nRaw_post() :\n\t#{request.raw_post}\n\nHeaders() :"

      ### Also more info, usually not that useful, always very verbose.
      ##add the HTML headers to the message in a slightly more readable format than simply headers.inspect
      #request.headers.each do |key, value|
      #  if value.is_a?(Hash)
      #    value.each do |a, b|
      #      @message << "\n\t\t#{a.inspect} : #{b.inspect}"
      #    end
      #  else
      #    @message << "\n\t#{key.inspect} : #{value.inspect}"
      #  end
      #end
      #send email
      Interact.error_report(@message, request.original_url, request.env["HTTP_USER_AGENT"]).deliver
    end
    render :file => "errors/500", :status => 500, :formats => [:html]
  end

  # clear cookies, used on 500 error pages
  def clear
    clear_cookies
    redirect_to root_path
  end

  protected

  def get_exception
    @exception ||= request.env["action_dispatch.exception"]
  end

  private

  def clear_cookies
    cookies.delete :cart
    reset_session
    cookies.delete :remember_token
    cookies.delete :cartX
    cookies.delete :cartY
    cookies.delete :motd
  end
end
