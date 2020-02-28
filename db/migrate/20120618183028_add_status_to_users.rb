class AddStatusToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :status, :string, default: "pending"
  end
end
