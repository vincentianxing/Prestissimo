class AddNonceExpiryToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :nonce_expiry, :datetime, deafault: DateTime.new(0)
  end
end
