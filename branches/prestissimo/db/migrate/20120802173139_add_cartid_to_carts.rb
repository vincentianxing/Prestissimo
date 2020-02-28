class AddCartidToCarts < ActiveRecord::Migration[4.2]
  def change
    add_column :carts, :cartid, :string
  end
end
