class AddLockedToReports < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :locked_by, :string 
  end
end
