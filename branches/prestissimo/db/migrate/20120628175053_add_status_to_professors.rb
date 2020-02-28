class AddStatusToProfessors < ActiveRecord::Migration[4.2]
  def change
    add_column :professors, :status, :string, default: "active"
  end
end
