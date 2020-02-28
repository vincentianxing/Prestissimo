class CreateSyllabuses < ActiveRecord::Migration[3.2]
  def change
    create_table :syllabuses do |t|
      t.string :path
      t.integer :course_id

      t.timestamps
    end
  end
end
