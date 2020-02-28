class AddIndexToKeysInSettings < ActiveRecord::Migration[3.2]
  def change
	  add_index :settings, :key
  end
end
