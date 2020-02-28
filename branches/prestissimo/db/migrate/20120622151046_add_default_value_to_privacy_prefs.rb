class AddDefaultValueToPrivacyPrefs < ActiveRecord::Migration[3.2]
  def change
		remove_column :users, :privacy_prefs
		add_column :users, :privacy_prefs, :text, default: ""
  end
end
