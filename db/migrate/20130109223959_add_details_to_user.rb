class AddDetailsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :major, :string
  end
end
