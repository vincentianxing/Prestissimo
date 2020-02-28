class AddProfIdToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :prof_id, :int
  end
end
