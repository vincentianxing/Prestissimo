class AddRememberTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :remember_token, :string
    add_index :users, :remember_token
    add_index :users, :email
  end
end
