class AddCnameToHubcourses < ActiveRecord::Migration[4.2]
  def change
    add_column :hubcourses, :cname, :string
  end
end
