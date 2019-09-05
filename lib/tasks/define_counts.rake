namespace :db do
	desc "set values for comment and user count settings"
	task set_counts: :environment do
		Setting.set('user_count',User.all.size.to_s)
		Setting.set('comment_count',Comment.all.size.to_s)
	end
end
