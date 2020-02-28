class AddStatusToCourses < ActiveRecord::Migration[3.2]
  def change
    add_column :courses, :status, :string
  end
end
