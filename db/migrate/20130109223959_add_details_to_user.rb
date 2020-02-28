class AddDetailsToUser < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :major, :string
  end
end
