class ChangeCnumInCourses < ActiveRecord::Migration
  def up
    change_column :courses, :cnum, :string, default: ""
    add_column :courses, :dept_long, :string, default: ""
    change_column :courses, :status, :string, default: ""
  end

  def down
    change_column :courses, :cnum, :integer
    remove_column :courses, :dept_long
    change_column :courses, :status, :string
  end
end
