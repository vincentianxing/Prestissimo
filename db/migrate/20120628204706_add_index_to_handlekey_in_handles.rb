class AddIndexToHandlekeyInHandles < ActiveRecord::Migration
  def change
    add_index :handles, :handlekey, unique: true
  end
end
