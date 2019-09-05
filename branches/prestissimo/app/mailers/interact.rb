class Interact < ActionMailer::Base
  default from: "do_not_reply@oprestissimo.com",
    return_path: 'info@oprestissimo.com'

  def activate(user)
    @user = user
    mail(to: user.email)
  end

  def change_pass(user)
    @user = user
    mail(to: user.email)
  end

  def reset_pass(user)
    @user = user
    mail(to: user.email)
  end

	def reveal_handle_user(user, admin, handle)
		@user = user
		@admin = admin
		@handle = handle
		mail(from: "info@oprestissimo.com",
				 to: user.email,
				 bcc: "info@oprestissimo.com",
				 subject: "OPrestissimo Commenter Nickname Revealed")
	end

	def mail_cart(requestip,cart,email,sender)
		@cart = cart
		@email = email
		@sender = sender
		if @sender
		  mail(to: email,
		       from: @sender.email,
		       'X-Cart-Sent-From' => requestip,
		       subject: "OPrestissimo Course Cart")
		else
		  mail(to: email,
		       'X-Cart-Sent-From' => requestip,
		       subject: "OPrestissimo Course Cart")
		end
	end

	def report_confirmation(sender, report)
		@sender = sender
		@report = report
		mail(from: "info@oprestissimo.com",
				 to: sender.email,
				 subject: "OPrestissimo Report Confirmation")
	end

  def admin_report_notice(sender, report)
    @sender = sender
    @report = report
    admins = User.find_all_by_admin(true)
    admin_list = Array.new
    admins.each do |a|
      admin_list << a.email
    end
    mail(to: admin_list,
	 subject: "New Report: " + report.title)
  end

	def to_reporter(reporter, message, report)
		@reporter = reporter
		@message = message
		@report = report
		mail(to: reporter.email,
				 bcc: "info@oprestissimo.com",
				 subject: "Your report at Prestissimo has been resolved!")
	end

	def to_reported(reported, message, report)
		@reported = reported
		@message = message
		@report = report
		mail(to: reported.email,
				 bcc: "info@oprestissimo.com",
				 subject: "Your activity on Prestissimo has been reported.")
	end

	def send_q(title, message, user)
		@title = title
		@message = message
		@user = user
		mail(to: "info@oprestissimo.com",
				 from: @user.email,
				 return_path: @user.email,
				 subject: @user.fname+" "+@user.lname+" has asked a question about Prestissimo!")
	end
end
