# == Schema Information
#
# Table name: carts
#
#  id         :integer(4)      not null, primary key
#  courses    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  cartid     :string(255)
#


class Cart < ActiveRecord::Base
  attr_accessible :courses
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
    self.courses.split(' ').each do |semcrn|
      Course.where(semcrn: semcrn).each do |course|
	course_array << course
      end
    end
    course_array.sort
  end

  def create_cartid
    self.cartid = Digest::MD5.hexdigest('cart'+id.to_s)
  end
end
