class AddHandlekeyToHandles < ActiveRecord::Migration[3.2]
  def change
    add_column :handles, :handlekey, :string
  end
end
