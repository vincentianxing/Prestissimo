namespace :db do
  desc 'establish settings'
  task initialize: :environment do
    # settings 
    settings = {}
    settings["current_semester"] = "Fall 2009"
    settings["semesters"] = "Fall 2009"
    settings["user_count"] = ""
    settings["comment_count"] = ""
    settings["admins"] = ""
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
    settings["profs_last_notified"] = ""
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
