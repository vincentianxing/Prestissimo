class ChangeTypeOfSemoffInCourses < ActiveRecord::Migration
  def up
    change_column :courses, :sem_off, :integer, limit: 1
  end

  def down
    change_column :courses, :sem_off, :binary, limit: 1
  end
end
