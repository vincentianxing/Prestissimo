class AddStatusToComments < ActiveRecord::Migration[3.2]
  def change
    add_column :comments, :status, :string, default: "active"
  end
end
