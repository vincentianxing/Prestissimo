# == Schema Information
#
# Table name: hubcourses
#
#  id            :integer(4)      not null, primary key
#  hub_id        :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  department_id :integer(4)
#  cnum          :integer(4)
#  cname         :string(255)
#


class Hubcourse < ActiveRecord::Base
  attr_accessible :hub_id, :cnum
  has_many :courses
  belongs_to :department
  acts_as_commentable

  default_scope { where(order: "hub_id") }

  def self.build(hub_id, cnum)
    h = Hubcourse.new
    h.hub_id = hub_id
    h.cnum = cnum
    h
  end
end

