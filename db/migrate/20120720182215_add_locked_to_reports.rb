class AddLockedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :locked_by, :string 
  end
end
