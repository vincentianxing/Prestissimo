class AddYearToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :year, :string
  end
end
