module CartsHelper


  def current_cart
	  @current_cart ||= set_cart
  end

  def set_cart
    if current_user
      unless current_user.cart
	current_user.create_cart
	current_user.save
      end
      return current_user.cart
    else
      if cookies[:cart]
	cart = Cart.where(cartid: cookies[:cart])
	if cart.size > 0
	  return cart[0]
	else
	  cookies.delete :cart
	  return nil
	end
      end
    end
  end

  def get_courses
    courses = Array.new
    if !current_cart.courses.blank?
	    current_cart.courses.split(' ').each do |semcrn|
		course = Course.find_by_semcrn(semcrn)
		#if course != nil
		courses << course
		#end
	    end
    else
	    courses = nil
    end
    courses.sort unless courses.nil?
  end
end
