class AddCnumToHubcourses < ActiveRecord::Migration[3.2]
  def change
    add_column :hubcourses, :cnum, :integer
  end
end
