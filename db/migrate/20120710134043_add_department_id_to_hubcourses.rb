class AddDepartmentIdToHubcourses < ActiveRecord::Migration[4.2]
  def change
    add_column :hubcourses, :department_id, :integer
  end
end
