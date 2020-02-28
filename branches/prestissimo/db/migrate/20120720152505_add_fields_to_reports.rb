class AddFieldsToReports < ActiveRecord::Migration[3.2]
  def change
    add_column :reports, :response, :text
    add_column :reports, :admin_email, :string
    add_column :reports, :resolved, :boolean, default: false
  end
end
