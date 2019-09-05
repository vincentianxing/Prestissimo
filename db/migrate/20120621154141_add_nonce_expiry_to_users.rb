class AddNonceExpiryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nonce_expiry, :datetime, deafault: DateTime.new(0)
  end
end
