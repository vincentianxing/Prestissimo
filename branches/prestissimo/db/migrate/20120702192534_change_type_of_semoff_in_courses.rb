class ChangeTypeOfSemoffInCourses < ActiveRecord::Migration[4.2]
  def up
    change_column :courses, :sem_off, :integer, limit: 1
  end

  def down
    change_column :courses, :sem_off, :binary, limit: 1
  end
end
