class ChangeTimeNames < ActiveRecord::Migration
  def up
    rename_column :courses, :start, :start_time
    rename_column :courses, :end, :end_time
  end

  def down
    rename_column :courses, :start_time, :start
    rename_column :courses, :end_time, :end
  end
end
