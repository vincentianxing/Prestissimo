class AddDeptLongToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :dept_long, :string
  end
end
