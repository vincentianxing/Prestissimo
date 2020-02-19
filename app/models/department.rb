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

class Department < ApplicationRecord

  has_and_belongs_to_many :professors, join_table: 'departments_professors'
  acts_as_commentable
  has_many :hubcourses

  def to_param
     dept
  end 

  def to_csv( enroll )
    qs = '( dept LIKE '+ActiveRecord::Base.connection.quote("%"+dept+"%") + ' AND status!="cancelled"'
    qs << ' AND ( enroll BETWEEN 1 AND 999 )' if (enroll == 0)
    qs << ' )'
    courses = Course.where(qs).sort
    CSV.generate do |csv|
      csv << Course.csv_headers 
      courses.each do |c|
        csv << Course.to_csv_row(c)
      end
    end
  end
end

