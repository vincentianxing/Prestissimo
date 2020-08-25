class Syllabus < ApplicationRecord
  belongs_to :course

  def add
  end

end
# == Schema Information
#
# Table name: syllabuses
#
#  id         :integer          not null, primary key
#  path       :string(255)
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

