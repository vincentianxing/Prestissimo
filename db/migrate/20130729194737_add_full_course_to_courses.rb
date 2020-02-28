class AddFullCourseToCourses < ActiveRecord::Migration[3.2]
  def change
    # add full_course column to courses table for FC/HC/CC attribute in new credit system
    add_column :courses, :full_course, :string
  end
end
