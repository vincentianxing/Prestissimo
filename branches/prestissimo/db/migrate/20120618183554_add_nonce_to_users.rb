class AddNonceToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :nonce, :string
  end
end
