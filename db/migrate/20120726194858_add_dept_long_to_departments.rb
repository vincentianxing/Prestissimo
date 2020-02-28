class AddDeptLongToDepartments < ActiveRecord::Migration[4.2]
  def change
    add_column :departments, :dept_long, :string
  end
end
