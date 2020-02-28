class AddStatusToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :status, :string
  end
end
