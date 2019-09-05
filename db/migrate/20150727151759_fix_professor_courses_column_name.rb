class FixProfessorCoursesColumnName < ActiveRecord::Migration
  def change
    rename_column :professors, :editable_courses, :my_classes
  end
end
