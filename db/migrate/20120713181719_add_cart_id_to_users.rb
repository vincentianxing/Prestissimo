class AddCartIdToUsers < ActiveRecord::Migration
  def up
    remove_column :users, :course_list
    add_column :users, :cart_id, :integer
  end

  def down
    add_column :users, :course_list, :string
y    remove_column :users, :cart_id
  end
end
