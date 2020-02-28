class AddDefaultValueToPrivacyPrefs < ActiveRecord::Migration[4.2]
  def change
		remove_column :users, :privacy_prefs
		add_column :users, :privacy_prefs, :text
  end
end
