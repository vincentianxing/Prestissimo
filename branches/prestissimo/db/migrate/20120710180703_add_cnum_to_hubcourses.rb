class AddCnumToHubcourses < ActiveRecord::Migration[4.2]
  def change
    add_column :hubcourses, :cnum, :integer
  end
end
