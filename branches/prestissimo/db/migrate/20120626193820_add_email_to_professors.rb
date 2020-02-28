class AddEmailToProfessors < ActiveRecord::Migration[4.2]
  def change
    add_column :professors, :email, :string
  end
end
