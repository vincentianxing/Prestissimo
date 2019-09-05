class AddStatusToComments < ActiveRecord::Migration
  def change
    add_column :comments, :status, :string, default: "active"
  end
end
