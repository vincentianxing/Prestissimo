class Syllabus < ApplicationRecord
  attr_accessible :path, :course_id

  belongs_to :course

  def add
  end

end
# == Schema Information
#
# Table name: syllabuses
#
#  id         :integer(4)      not null, primary key
#  path       :string(255)
#  course_id  :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

