class AddNicknameToUsers < ActiveRecord::Migration[3.2]
  def change
    add_column :users, :nickname, :string
  end
end
