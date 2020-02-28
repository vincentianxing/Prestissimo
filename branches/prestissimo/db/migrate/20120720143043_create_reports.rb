class CreateReports < ActiveRecord::Migration[4.2]
  def change
    create_table :reports do |t|
      t.string :title
      t.text :body
      t.string :reporter
			t.references :reportable, polymorphic: true

      t.timestamps
    end
  end
end
