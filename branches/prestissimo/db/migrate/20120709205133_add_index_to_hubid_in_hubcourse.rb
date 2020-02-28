class AddIndexToHubidInHubcourse < ActiveRecord::Migration[4.2]
  def change
    add_index :hubcourses, :hub_id, unique: true
  end
end
