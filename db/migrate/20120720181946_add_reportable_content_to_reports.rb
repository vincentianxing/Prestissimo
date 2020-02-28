class AddReportableContentToReports < ActiveRecord::Migration[4.2]
  def change
    add_column :reports, :reportable_content, :text
  end
end
