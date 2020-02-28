class AddCartIdToUsers < ActiveRecord::Migration[3.2]
  def up
    remove_column :users, :course_list
    add_column :users, :cart_id, :integer
  end

  def down
    add_column :users, :course_list, :string
y    remove_column :users, :cart_id
  end
end
