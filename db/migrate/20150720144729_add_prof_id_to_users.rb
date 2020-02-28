class AddProfIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :prof_id, :int
  end
end
