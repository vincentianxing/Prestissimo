class AddIndexToCartidInCarts < ActiveRecord::Migration[4.2]
  def change
    add_index :carts, :cartid
  end
end
