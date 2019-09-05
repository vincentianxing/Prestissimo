# find users w/ expired nonce in database
# if their account is active, make the nonce nil and the nonce_expiry 0
# if account is pending, delete the account

namespace :db do
  desc "Remove nonce/user for accounts with expired nonce"
  task nonce_cleanse: :environment do
    User.all.each do |user|
      # check if nonce is expired (if it is, nonce_active? will make nonce nil and set expiry to 0
      if !user.nonce_active?
	# if the user is pending, delete it
	if user.status == "pending"
	  user.delete
	end
      end
    end
  end

  desc "remove expired user accounts"
  task filter_users: :environment do
  end
end
