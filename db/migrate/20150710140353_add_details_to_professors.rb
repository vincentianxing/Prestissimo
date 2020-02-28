class AddDetailsToProfessors < ActiveRecord::Migration[3.2]
  def change
    add_column :professors, :can_edit, :boolean, :default => true
    add_column :professors, :editable_courses, :string
  end
end
