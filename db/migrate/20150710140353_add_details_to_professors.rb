class AddDetailsToProfessors < ActiveRecord::Migration
  def change
    add_column :professors, :can_edit, :boolean, :default => true
    add_column :professors, :editable_courses, :string
  end
end
