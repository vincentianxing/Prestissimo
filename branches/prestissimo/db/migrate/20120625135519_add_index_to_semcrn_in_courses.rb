class AddIndexToSemcrnInCourses < ActiveRecord::Migration
  def change
    add_index :courses, :semcrn
  end
end
