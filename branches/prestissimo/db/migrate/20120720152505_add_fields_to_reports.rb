class AddFieldsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :response, :text
    add_column :reports, :admin_email, :string
    add_column :reports, :resolved, :boolean, default: false
  end
end
