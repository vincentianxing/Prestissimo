class FixDepartmentProfessorJoin < ActiveRecord::Migration[3.2]
  def up
    drop_table :professors_departments
    create_table :departments_professors, id: false do |t|
      t.references :professor, null: false
      t.references :department, null: false
    end

    add_index(:departments_professors, [:professor_id, :department_id], unique: true)
  end

  def down
    drop_table :departments_professors
    create_table :professors_departments, id: false do |t|
      t.references :professor, null: false
      t.references :department, null: false
    end

    add_index(:professors_departments, [:professor_id, :department_id], unique: true)
  end
end
