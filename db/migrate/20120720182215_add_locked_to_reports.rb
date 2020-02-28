class AddLockedToReports < ActiveRecord::Migration[3.2]
  def change
    add_column :reports, :locked_by, :string 
  end
end
