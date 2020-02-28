class CreateCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :courses do |t|
      t.string :dept
      t.string :cname
      t.string :professor
      t.string :proficiencies
      t.string :building
      t.string :room
      t.integer :cnum
      t.integer :crn

      t.timestamps
    end
  end
end
