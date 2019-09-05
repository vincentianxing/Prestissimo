class AddCnumToHubcourses < ActiveRecord::Migration
  def change
    add_column :hubcourses, :cnum, :integer
  end
end
