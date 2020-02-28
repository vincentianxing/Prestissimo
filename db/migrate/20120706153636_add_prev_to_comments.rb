class AddPrevToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :prev, :integer
  end
end
