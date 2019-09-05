class CreateSyllabuses < ActiveRecord::Migration
  def change
    create_table :syllabuses do |t|
      t.string :path
      t.integer :course_id

      t.timestamps
    end
  end
end
