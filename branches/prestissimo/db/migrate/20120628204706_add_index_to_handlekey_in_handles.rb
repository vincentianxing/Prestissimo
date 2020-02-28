class AddIndexToHandlekeyInHandles < ActiveRecord::Migration[4.2]
  def change
    add_index :handles, :handlekey, unique: true
  end
end
