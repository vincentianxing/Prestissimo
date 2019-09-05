class AddCnameToHubcourses < ActiveRecord::Migration
  def change
    add_column :hubcourses, :cname, :string
  end
end
