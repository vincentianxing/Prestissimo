class ChangeSettingValueToText < ActiveRecord::Migration[6.0]
  def up
    change_column :settings, :value, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :settings, :value, :string
  end
end
