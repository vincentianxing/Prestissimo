class AddCorrectPrivacyPrefsToUsers < ActiveRecord::Migration
  def change
		add_column :users, :privacy_prefs, :text
  end
end
