class AddPrevToComments < ActiveRecord::Migration[3.2]
  def change
    add_column :comments, :prev, :integer
  end
end
