class AddCourselistToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :course_list, :text
  end
end
