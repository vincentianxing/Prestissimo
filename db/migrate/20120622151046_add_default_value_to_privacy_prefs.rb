class AddDefaultValueToPrivacyPrefs < ActiveRecord::Migration
  def change
		remove_column :users, :privacy_prefs
		add_column :users, :privacy_prefs, :text, default: ""
  end
end
