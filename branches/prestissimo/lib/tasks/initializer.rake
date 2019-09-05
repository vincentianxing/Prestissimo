namespace :db do
  desc 'establish settings and create master admin user'
  task initialize: :environment do
    params = {}
    params[:user] = {}
    params[:user][:password] = 'this is the way my college career ends'
    params[:user][:password_confirmation] = 'this is the way my college career ends'
    params[:user][:email] = 'oprestissimo@gmail.com'
    madmin = User.new(params[:user])
    madmin.toggle(:admin)
    madmin.fname = 'Master'
    madmin.lname = 'Admin'
    madmin.status = 'active'
    madmin.role = 'Student'
    if madmin.save
      puts 'Master Admin account created'
    end
    # settings 
    settings = {}
    settings["current_semester"] = "Fall 2009"
    settings["semesters"] = "Fall 2009"
    settings["user_count"] = ""
    settings["comment_count"] = ""
    settings["admins"] = "Master Admin"
    settings["high_comment_score"] = "5"
    settings["low_comment_score"] = "-5"
    settings["courses_revision_number"] = "1.1"
    settings["enrollment_revision_number"] = "1.1"
    settings["comment_report_threshold"] = "5"
    settings["handle_report_threshold"] = "5"
    settings["user_report_threshold"] = "5"
    settings["handle_abuse_threshold"] = "5"
    settings["motd"] = ""
    settings["courses_last_updated"] = ""
    settings.each do |key,value|
      s = Setting.new
      s.key = key
      s.value = value
      if s.save
	puts "Setting #{s.key} set to #{s.value}"
      end
    end
  end
end
