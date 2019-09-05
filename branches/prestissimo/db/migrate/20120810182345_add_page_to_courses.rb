class AddPageToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :page, :integer, default: 0
  end
end
