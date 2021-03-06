class RenameAttributesToDistributionsInCourses < ActiveRecord::Migration
  def up
    add_column :courses, :distributions, :string
    remove_column :courses, :attributes
  end

  def down
    add_column :courses, :attributes, :string
    remove_column :courses, :distributions
  end
end
