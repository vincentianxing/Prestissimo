class AddCourselistToUsers < ActiveRecord::Migration
  def change
    add_column :users, :course_list, :text
  end
end
