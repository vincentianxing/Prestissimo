class AddCnameToHubcourses < ActiveRecord::Migration[3.2]
  def change
    add_column :hubcourses, :cname, :string
  end
end
