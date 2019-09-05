class JoinProfessorsAndDepartments < ActiveRecord::Migration
  def change
    create_table :professors_departments, id: false do |t|
      t.references :professor, null: false
      t.references :department, null: false
    end

    add_index(:professors_departments, [:professor_id, :department_id], unique: true)
  end
end
