class CreateDepartments < ActiveRecord::Migration[3.2]
  def change
    create_table :departments do |t|
      t.string :dept

      t.timestamps
    end
  end
end
