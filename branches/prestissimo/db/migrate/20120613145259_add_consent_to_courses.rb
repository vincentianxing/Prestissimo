class AddConsentToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :consent, :boolean
  end
end
