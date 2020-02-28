class AddRoleToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :role, :string
  end
end
