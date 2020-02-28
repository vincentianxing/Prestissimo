class ChangeProfessorCourseJoin < ActiveRecord::Migration[4.2]
  def up
	  drop_table :professors_courses
	  create_table :courses_professors, id: false do |t|
		  t.references :course, null: false
		  t.references :professor, null: false
	  end
	  add_index(:courses_professors, [:professor_id, :course_id], unique: true)
  end

  def down
	  drop_table :courses_professors
	  create_table :professors_courses, id: false do |t|
		  t.references :professor, null: false
		  t.references :course, null: false
	  end
	  add_index(:professors_courses, [:professor_id, :course_id], unique: true)
  end
end
