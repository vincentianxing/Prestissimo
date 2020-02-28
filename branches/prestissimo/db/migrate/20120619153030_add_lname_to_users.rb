class AddLnameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :lname, :string
  end
end
