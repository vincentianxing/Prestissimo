class AddStatusToProfessors < ActiveRecord::Migration[3.2]
  def change
    add_column :professors, :status, :string, default: "active"
  end
end
