class AddNotesToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :notes, :text, default: ""
  end
end
