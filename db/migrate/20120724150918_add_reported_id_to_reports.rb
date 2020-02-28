class AddReportedIdToReports < ActiveRecord::Migration[3.2]
  def change
    add_column :reports, :reported_id, :integer
  end
end
