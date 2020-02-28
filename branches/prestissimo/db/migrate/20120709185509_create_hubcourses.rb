class CreateHubcourses < ActiveRecord::Migration[3.2]
  def change
    create_table :hubcourses do |t|
      t.string :hub_id

      t.timestamps
    end

    add_column :courses, :hubcourse_id, :integer
  end
end
