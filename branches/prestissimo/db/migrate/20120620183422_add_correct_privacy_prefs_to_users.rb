class AddCorrectPrivacyPrefsToUsers < ActiveRecord::Migration[3.2]
  def change
		add_column :users, :privacy_prefs, :text, default: ""
  end
end
