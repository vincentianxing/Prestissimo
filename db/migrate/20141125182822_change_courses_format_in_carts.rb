class ChangeCoursesFormatInCarts < ActiveRecord::Migration[3.2]
  def up
    change_column :carts, :courses, :text, :limit => 16777215
  end

  def down
    change_column :carts, :courses, :string
  end
end
