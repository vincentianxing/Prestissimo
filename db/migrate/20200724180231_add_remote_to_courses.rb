class AddRemoteToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :remote, :string
  end
end
