class AddIndexToSemcrnInCourses < ActiveRecord::Migration[3.2]
  def change
    add_index :courses, :semcrn
  end
end
