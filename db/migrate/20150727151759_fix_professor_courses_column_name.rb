class FixProfessorCoursesColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :professors, :editable_courses, :my_classes
  end
end
