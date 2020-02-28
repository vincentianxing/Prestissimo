class AddConsentToCourses < ActiveRecord::Migration[3.2]
  def change
    add_column :courses, :consent, :boolean
  end
end
