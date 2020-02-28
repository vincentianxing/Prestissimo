class AddCorrectPrivacyPrefsToUsers < ActiveRecord::Migration[4.2]
  def change
		add_column :users, :privacy_prefs, :text, default: ""
  end
end
