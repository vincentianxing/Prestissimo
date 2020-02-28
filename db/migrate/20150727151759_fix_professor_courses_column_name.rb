class FixProfessorCoursesColumnName < ActiveRecord::Migration[3.2]
  def change
    rename_column :professors, :editable_courses, :my_classes
  end
end
