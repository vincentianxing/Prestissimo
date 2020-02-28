class AddCartidToCarts < ActiveRecord::Migration[3.2]
  def change
    add_column :carts, :cartid, :string
  end
end
