class AddReportedIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reported_id, :integer
  end
end
