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
  attr_accessible :fname, :lname, :email, :nickname, :contact, :phone, :office, :content, :url

  #Relations to other models
  acts_as_commentable
  has_and_belongs_to_many :courses, join_table: 'courses_professors'
  has_and_belongs_to_many :departments, join_table: 'departments_professors'

  #Changes status of a professor
  def toggle_status
    if (self.status == "dark")
      self.status = "active"
    else
      self.status = "dark"
    end
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
