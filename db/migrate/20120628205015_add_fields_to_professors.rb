class AddFieldsToProfessors < ActiveRecord::Migration
  def change
    add_column :professors, :office, :string
    add_column :professors, :phone, :string
    add_column :professors, :contact, :string
    add_column :professors, :url, :string
    add_column :professors, :content, :text
  end
end
