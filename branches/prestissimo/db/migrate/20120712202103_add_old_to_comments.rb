class AddOldToComments < ActiveRecord::Migration[3.2]
  def change
    add_column :comments, :old, :boolean, default: false
  end
end
