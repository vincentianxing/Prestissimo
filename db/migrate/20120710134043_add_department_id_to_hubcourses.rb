class AddDepartmentIdToHubcourses < ActiveRecord::Migration[3.2]
  def change
    add_column :hubcourses, :department_id, :integer
  end
end
