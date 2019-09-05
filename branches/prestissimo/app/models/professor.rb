# == Schema Information
#
# Table name: professors
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  email      :string(255)
#  fname      :string(255)
#  lname      :string(255)
#  nickname   :string(255)
#  status     :string(255)     default("active")
#  office     :string(255)
#  phone      :string(255)
#  contact    :string(255)
#  url        :string(255)
#  content    :text
#

class Professor < ActiveRecord::Base
	#These attributes are changeable via update_attributes
  attr_accessible :fname, :lname, :email, :nickname

	#Relations to other models
  acts_as_commentable
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :departments

	#Changes status of a professor
  def toggle_status
    if (self.status == "dark")
      self.status = "active"
    else
      self.status = "dark"
    end
  end
end
