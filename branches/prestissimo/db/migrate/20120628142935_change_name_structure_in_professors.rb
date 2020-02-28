class ChangeNameStructureInProfessors < ActiveRecord::Migration[4.2]
  def up
    remove_column :professors, :name
    add_column :professors, :fname, :string
    add_column :professors, :lname, :string
    add_column :professors, :nickname, :string
  end

  def down
    add_column :professors, :name, :string
    remove_column :professors, :fname
    remove_column :professors, :lname
    remove_column :professors, :nickname
  end
end
