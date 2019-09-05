class CreateHandles < ActiveRecord::Migration
  def change
    create_table :handles do |t|
      t.string :username
      t.boolean :is_mute, default: false

      t.timestamps
    end
  end
end
