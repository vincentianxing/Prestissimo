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


class Hubcourse < ApplicationRecord
  attr_accessible :hub_id, :cnum
  has_many :courses
  belongs_to :department
  acts_as_commentable

  default_scope { order(:hub_id) }

  def self.build(hub_id, cnum)
    h = Hubcourse.new
    h.hub_id = hub_id
    h.cnum = cnum
    h
  end

  def to_param
    "#{hub_id}".gsub(' ', '-')
  end

  def to_csv(enroll)
    CSV.generate do |csv|
      csv << Course.csv_headers 
      self.courses.sort.each do |c|
        csv << Course.to_csv_row(c) unless ((enroll == 0) && (c.enroll == 0)) || (c.status == "cancelled")
      end
    end
  end
end
