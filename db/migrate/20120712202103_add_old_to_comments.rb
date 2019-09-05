class AddOldToComments < ActiveRecord::Migration
  def change
    add_column :comments, :old, :boolean, default: false
  end
end
