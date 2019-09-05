class AddPrevToComments < ActiveRecord::Migration
  def change
    add_column :comments, :prev, :integer
  end
end
