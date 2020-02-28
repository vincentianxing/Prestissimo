class AddDeptLongToDepartments < ActiveRecord::Migration[3.2]
  def change
    add_column :departments, :dept_long, :string
  end
end
