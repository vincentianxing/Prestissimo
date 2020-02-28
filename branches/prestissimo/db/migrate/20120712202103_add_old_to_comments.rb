class AddOldToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :old, :boolean, default: false
  end
end
