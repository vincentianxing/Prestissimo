module HandlesHelper
  def current_handle
    @current_handle = Handle.find_by_handlekey(current_user.handlekey)
  end
end
