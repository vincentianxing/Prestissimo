class RemoveDetailsFromUsers < ActiveRecord::Migration[3.2]
  def up
    remove_column :users, :gender
    remove_column :users, :password_digest
    remove_column :users, :nonce
    remove_column :users, :nonce_expiry
  end

  def down
    add_column :users, :nonce_expiry, :datetime
    add_column :users, :nonce, :string
    add_column :users, :password_digest, :string
    add_column :users, :gender, :string
  end
end
