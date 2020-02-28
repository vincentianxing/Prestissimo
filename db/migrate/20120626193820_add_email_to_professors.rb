class AddEmailToProfessors < ActiveRecord::Migration[3.2]
  def change
    add_column :professors, :email, :string
  end
end
