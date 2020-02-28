class AddIndexToCartidInCarts < ActiveRecord::Migration[3.2]
  def change
    add_index :carts, :cartid
  end
end
