class CreateProfessors < ActiveRecord::Migration[4.2]
  def change
    create_table :professors do |t|
      t.string :name

      t.timestamps
    end
  end
end
