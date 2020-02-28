class ChangeDataTypeForDaysOfTheWeek < ActiveRecord::Migration[4.2]
  def up
		change_table :courses do |t|
			t.change :days_off, :string
		end
  end

  def down
		change_table :courses do |t|
			t.change :days_off, :binary
		end
  end
end
