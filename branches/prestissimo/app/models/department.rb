# == Schema Information
#
# Table name: departments
#
#  id         :integer(4)      not null, primary key
#  dept       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  dept_long  :string(255)
#

class Department < ActiveRecord::Base
  attr_accessible :dept

  has_and_belongs_to_many :professors
  acts_as_commentable
  has_many :hubcourses
end

