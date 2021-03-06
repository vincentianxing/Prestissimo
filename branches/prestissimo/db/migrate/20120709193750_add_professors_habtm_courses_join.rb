class AddProfessorsHabtmCoursesJoin < ActiveRecord::Migration
  def change
    create_table :professors_courses, id: false do |t|
      t.references :professor, null: false
      t.references :course, null: false
    end

    add_index(:professors_courses, [:professor_id, :course_id], unique: true)
  end
end
