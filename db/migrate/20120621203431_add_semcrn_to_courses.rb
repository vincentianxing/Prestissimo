class AddSemcrnToCourses < ActiveRecord::Migration[3.2]
  def change
    add_column :courses, :semcrn, :string
  end
end
