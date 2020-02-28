class AddConsentToCourses < ActiveRecord::Migration[4.2]
  def change
    add_column :courses, :consent, :boolean
  end
end
