class AddHandlekeyToHandles < ActiveRecord::Migration[4.2]
  def change
    add_column :handles, :handlekey, :string
  end
end
