class AddSemcrnToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :semcrn, :string
  end
end
