class AddUserIdToReports < ActiveRecord::Migration[3.2]
  def up 
	  remove_column :reports, :reporter
	  add_column :reports, :user_id, :integer
  end

  def down
	  add_column :reports, :reporter, :string
	  remove_column :reports, :user_id
  end
end
