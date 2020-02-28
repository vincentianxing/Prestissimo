class AddGenderToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :gender, :string
  end
end
