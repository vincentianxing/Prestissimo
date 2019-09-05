class AddDepartmentIdToHubcourses < ActiveRecord::Migration
  def change
    add_column :hubcourses, :department_id, :integer
  end
end
