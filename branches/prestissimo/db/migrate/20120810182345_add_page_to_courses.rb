class AddPageToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :page, :integer, default: 0
  end
end
