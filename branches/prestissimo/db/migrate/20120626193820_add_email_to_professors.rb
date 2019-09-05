class AddEmailToProfessors < ActiveRecord::Migration
  def change
    add_column :professors, :email, :string
  end
end
