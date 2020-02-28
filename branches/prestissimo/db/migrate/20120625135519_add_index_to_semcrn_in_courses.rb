class AddIndexToSemcrnInCourses < ActiveRecord::Migration[4.2]
  def change
    add_index :courses, :semcrn
  end
end
