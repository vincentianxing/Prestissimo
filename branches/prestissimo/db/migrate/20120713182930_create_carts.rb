class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.string :courses
      
      t.timestamps
    end
  end
end
