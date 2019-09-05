namespace :db do

  desc 'respond to hated things'
  task report_response: :environment do
    # find all objects that have 5 unique reports without admin acknowledgement
    reports = Array.new
    # comments
    maxreports = Setting.get_val("comment_report_threshold").to_i
    Report.where(response: "", reportable_type: "Comment").order(:reportable_id, :user_id).each do |r|
      if reports.size == 0 || (reports[0].reportable_id == r.reportable_id && reports[0].user_id != r.user_id)
	reports << r
      elsif reports[0].reportable_id != r.reportable_id
	if reports.size >= maxreports
	  c = Comment.find(reports.last.reportable_id)
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  c.toggle_status('hidden') unless c.status == 'hidden'
	  c.save
	  response = "Comment auto-hidden due to significant reports of abuse."
	  to_reporter = "The comment you reported has been automatically hidden due to a significant quantity of complaints." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "Your comment has been muted automatically due to numerous reports of abuse from users."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
	reports = Array.new
	reports << r
      end
    end
	if reports.size >= maxreports
	  c = Comment.find(reports.last.reportable_id)
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  c.toggle_status('hidden') unless c.status == 'hidden'
	  c.save
	  response = "Comment auto-hidden due to significant reports of abuse."
	  to_reporter = "The comment you reported has been automatically hidden due to a significant quantity of complaints." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "Your comment has been muted automatically due to numerous reports of abuse from users."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
    # handles
    reports = Array.new
    maxreports = Setting.get_val("handle_report_threshold").to_i
    Report.where(response: "", reportable_type: "Handle").order(:reportable_id, :user_id).each do |r|
      if reports.size == 0 || (reports[0].reportable_id == r.reportable_id && reports[0].user_id != r.user_id)
	reports << r
      elsif reports[0].reportable_id != r.reportable_id
	if reports.size >= maxreports
	  h = Handle.find(reports.last.reportable_id)
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  h.mute
	  h.save
	  response = "Commentor auto-muted due to significant reports of abuse."
	  to_reporter = "The commentor you reported has been automatically muted due to a significant quantity of complaints." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "You have been muted automatically due to numerous reports of abuse from users."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
	reports = Array.new
	reports << r
      end
    end
	if reports.size >= maxreports
	  h = Handle.find(reports.last.reportable_id)
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  h.mute
	  h.save
	  response = "Commentor auto-muted due to significant reports of abuse."
	  to_reporter = "The commentor you reported has been automatically muted due to a significant quantity of complaints." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "You have been muted automatically due to numerous reports of abuse from users."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
    # users
    reports = Array.new
    maxreports = Setting.get_val("user_report_threshold").to_i
    Report.where(response: "", reportable_type: "User").order(:reportable_id, :user_id).each do |r|
      if reports.size == 0 || (reports[0].reportable_id == r.reportable_id && reports[0].user_id != r.user_id)
	reports << r
      elsif reports[0].reportable_id != r.reportable_id
	if reports.size >= maxreports
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  response = "Email sent to reported user."
	  to_reporter = "An email has been sent to the user you reported to inform that the admins will take action." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "A significant number of users have reported your profile page. An admin will contact you soon about further actions to be taken."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
	reports = Array.new
	reports << r
      end
    end
	if reports.size >= maxreports
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  response = "Email sent to reported user."
	  to_reporter = "An email has been sent to the user you reported to inform that the admins will take action." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "A significant number of users have reported your profile page. An admin will contact you soon about further actions to be taken."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
    # handles (total sum of reports)
    reports = Array.new
    maxreports = Setting.get_val("handle_abuse_threshold").to_i
    Report.where('resolved = ? AND reportable_type != ?', false, 'User').order(:reported_id).each do |r|
      if reports.size == 0 || reports[0].reported_id == r.reported_id
	reports << r
      else
	if reports.size >= maxreports
	  h = Handle.find_by_handlekey(User.find(reports.last.reported_id).handlekey)
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  h.mute
	  h.save
	  response = "Commentor auto-muted due to significant reports of abuse."
	  to_reporter = "The commentor you reported has been automatically muted due to a significant quantity of complaints." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "You have been muted automatically due to numerous reports of abuse from users."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
	reports = Array.new
	reports << r
      end
    end
	if reports.size >= maxreports
	  h = Handle.find_by_handlekey(User.find(reports.last.reported_id).handlekey)
	  response = ""
	  to_reported = ""
	  to_reporter = ""
	  h.mute
	  h.save
	  response = "Commentor auto-muted due to significant reports of abuse."
	  to_reporter = "The commentor you reported has been automatically muted due to a significant quantity of complaints." 
	  response << "\n\nMessage to Complainant:\n#{to_reporter}" 	  
	  to_reported = "You have been muted automatically due to numerous reports of abuse from users."
	  response << "\n\nMessage to Violator:\n#{to_reported}"
	  # send each response, update reports
	  update_reports(reports,to_reporter,to_reported,response)
	end
  end

  def update_reports(reports,to_reporter,to_reported,response)
	reports.each do |report|
	  Interact.to_reporter(report.user, to_reporter, report).deliver
	  Interact.to_reported(report.reported, to_reported, report).deliver
	  report.unresolve(User.find(1), response)
	  report.save
	end
  end

  desc 'comments with lots of downvotes get hidden'
  task hide_neg_comments: :environment do
    lowscore = Setting.get_val('low_comment_score').to_i || -5
    Comment.where('status != ?','hidden').each do |c|
      if c.score < lowscore
	c.toggle_status('hidden')
      end
    end
  end
end
