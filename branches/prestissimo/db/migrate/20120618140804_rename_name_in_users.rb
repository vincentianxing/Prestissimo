class RenameNameInUsers < ActiveRecord::Migration[3.2]
  def up
    rename_column :users, :name, :fname
  end

  def down
    rename_column :users, :fname, :name
  end
end
