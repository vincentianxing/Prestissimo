namespace :db do
	roomnumbers = [101, 121, 123, 227, 237, 239, 241, 243, 321, 323]

	desc "create 10 test users for user study"
	task createTestUsers: :environment do
	  roomnumbers.each { |room|
	    user = User.new({ email: "testuser#{room}@oberlin.edu", password: "#{room}password"})
	    user.fname = 'TestUser'
	    user.lname = "Room#{room}"
	    user.status = 'active'
	    if user.save
	      puts "User with email #{user.email} created!"
	    end
	  }
	end

	desc "delete 10 test users for user study"
	task deleteTestUsers: :environment do
	  roomnumbers.each { |room|
	    user = User.find_by_email("testuser#{room}@oberlin.edu")
	    if user.destroy
	      puts "User with email #{user.email} destroyed!"
	    end
	  }
	end

end
