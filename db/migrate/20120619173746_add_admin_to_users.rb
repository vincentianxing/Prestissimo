class AddAdminToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
