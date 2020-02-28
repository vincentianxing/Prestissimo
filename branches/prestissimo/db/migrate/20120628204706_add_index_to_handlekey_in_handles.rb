class AddIndexToHandlekeyInHandles < ActiveRecord::Migration[3.2]
  def change
    add_index :handles, :handlekey, unique: true
  end
end
