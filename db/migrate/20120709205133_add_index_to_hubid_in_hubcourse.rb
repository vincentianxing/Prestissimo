class AddIndexToHubidInHubcourse < ActiveRecord::Migration
  def change
    add_index :hubcourses, :hub_id, unique: true
  end
end
