# == Schema Information
#
# Table name: carts
#
#  id            :integer          not null, primary key
#  courses       :text(16777215)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cartid        :string(255)
#  total_credits :float(53)
#


class Cart < ApplicationRecord
  has_one :user
  has_one :cart_page

  after_create do |u|
    u.create_cartid
    u.save
  end

  def set_courses(course_string)
	  self.courses = course_string
  end
  
  def get_courses
    course_array = Array.new
    unless courses.nil?
	self.courses.split(' ').each do |semcrn|
	    Course.where(semcrn: semcrn).each do |course|
		course_array << course
	    end
	end
    end
    course_array.sort
  end

  def create_cartid
    self.cartid = Digest::MD5.hexdigest('cart'+id.to_s)
  end

  def to_csv
    courses = get_courses
    CSV.generate do |csv|
      csv << Course.csv_headers 
      courses.each do |c|
        csv << Course.to_csv_row(c)
      end
    end
  end

  # def credits(params, error, current_user, newcourses)
  #   @hours = 0
  #   params.each do |c|
  #     course = Course.find_by_semcrn(c) 
  #     if !error
  #       if course.crmax != course.crmin
  #         @hours += course.crmin - course.crmax
  #       else
  #         @hours += course.crmax
  #       end
  #     end
  #     total_credits = current_user.cart.total_credits.to_i 
  #     total_credits += @hours #unless newcourses.include? course.semcrn
  #     current_user.cart.total_credits = total_credits
  #   end
  #   current_user.cart.update!( total_credits: total_credits )
  # end

end
