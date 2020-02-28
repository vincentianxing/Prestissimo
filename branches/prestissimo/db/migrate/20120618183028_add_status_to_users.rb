class AddStatusToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :status, :string, default: "pending"
  end
end
