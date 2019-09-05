class AddIndexToCartidInCarts < ActiveRecord::Migration
  def change
    add_index :carts, :cartid
  end
end
