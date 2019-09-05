class AddSemcrnToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :semcrn, :string
  end
end
