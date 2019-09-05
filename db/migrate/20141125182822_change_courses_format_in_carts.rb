class ChangeCoursesFormatInCarts < ActiveRecord::Migration
  def up
    change_column :carts, :courses, :text, :limit => 16777215
  end

  def down
    change_column :carts, :courses, :string
  end
end
