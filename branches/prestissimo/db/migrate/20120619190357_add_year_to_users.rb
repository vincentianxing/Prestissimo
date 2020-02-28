class AddYearToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :year, :string
  end
end
