class CreateSettings < ActiveRecord::Migration[3.2]
  def change
    create_table :settings do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
