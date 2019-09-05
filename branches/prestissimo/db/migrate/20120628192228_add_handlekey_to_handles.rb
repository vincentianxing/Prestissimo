class AddHandlekeyToHandles < ActiveRecord::Migration
  def change
    add_column :handles, :handlekey, :string
  end
end
