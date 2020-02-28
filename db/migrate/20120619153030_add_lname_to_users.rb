class AddLnameToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :lname, :string
  end
end
