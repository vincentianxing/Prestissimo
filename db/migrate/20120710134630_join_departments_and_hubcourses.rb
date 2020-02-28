class JoinDepartmentsAndHubcourses < ActiveRecord::Migration[4.2]
  def change
    create_table :departments_hubcourses, id: false do |t|
      t.references :department, null: false
      t.references :hubcourse, null: false
    end

    add_index(:departments_hubcourses, [:department_id, :hubcourse_id], unique: true)
  end
end
