class AddIndexToKeysInSettings < ActiveRecord::Migration[4.2]
  def change
	  add_index :settings, :key
  end
end
