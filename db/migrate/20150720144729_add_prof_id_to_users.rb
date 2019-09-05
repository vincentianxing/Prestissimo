class AddProfIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prof_id, :int
  end
end
