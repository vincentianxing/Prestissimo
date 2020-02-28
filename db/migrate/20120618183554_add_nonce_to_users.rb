class AddNonceToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :nonce, :string
  end
end
