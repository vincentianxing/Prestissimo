class AddReportableContentToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reportable_content, :text
  end
end
