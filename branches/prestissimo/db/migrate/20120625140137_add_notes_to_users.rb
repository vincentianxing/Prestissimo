class AddNotesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notes, :text, default: ""
  end
end
