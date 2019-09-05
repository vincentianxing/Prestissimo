class AddDetailsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :prof_desc, :text
    add_column :courses, :which_desc, :string
    add_column :courses, :new_desc_action, :string
    add_column :courses, :prof_note, :text
    add_column :courses, :display_prof_note, :boolean, :default => true
    add_column :courses, :notify_profs, :string
    add_column :courses, :recent_edit, :string
    add_column :courses, :changed_fields, :string
  end
end
