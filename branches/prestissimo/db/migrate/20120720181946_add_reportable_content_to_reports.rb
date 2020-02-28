class AddReportableContentToReports < ActiveRecord::Migration[3.2]
  def change
    add_column :reports, :reportable_content, :text
  end
end
