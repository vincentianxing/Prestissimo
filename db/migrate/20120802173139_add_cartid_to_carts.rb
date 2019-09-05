class AddCartidToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :cartid, :string
  end
end
