class Interact < ActionMailer::Base
  default from: "do_not_reply@oprestissimo.com",
          return_path: "info@oprestissimo.com"

  def reveal_handle_user(user, admin, handle)
    @user = user
    @admin = admin
    @handle = handle
    mail(from: "info",
         to: user.email,
         bcc: "info@oprestissimo.com",
         subject: "OPrestissimo Commenter Nickname Revealed")
  end

  def mail_cart(requestip, cart, email, sender)
    @cart = cart
    @email = email
    @sender = sender
    attachments["cart.csv"] = CSV.generate do |csv|
      csv << Course.csv_headers
      cart.each do |c|
        csv << Course.to_csv_row(c)
      end
    end
    if @sender
      mail(to: email,
           from: @sender.email,
           "X-Cart-Sent-From" => requestip,
           subject: "OPrestissimo Course Cart")
    else
      mail(to: email,
           "X-Cart-Sent-From" => requestip,
           subject: "OPrestissimo Course Cart")
    end
  end

  def report_confirmation(sender, report)
    @sender = sender
    @report = report
    mail(from: "info",
         to: sender.email,
         subject: "OPrestissimo Report Confirmation")
  end

  def admin_report_notice(sender, report)
    @sender = sender
    @report = report
    admins = User.where(admin: true).to_a
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
    mail(to: "info",
         from: @user.email,
         return_path: @user.email,
         subject: @user.fname + " " + @user.lname + " has asked a question about Prestissimo!")
  end

  def send_e(title, message, user)
    @title = title
    @message = message
    @user = user
    mail(to: "info",
         from: @user.email,
         return_path: @user.email,
         subject: "#{title}: #{@user.fname} #{@user.lname}")
  end

  def error_report(message, page, browser)
    @message = message
    @page = page
    @browser = browser
    mail(to: "info",
         subject: "A 500 server error has occurred!")
  end

  def notify_professor(course, email)

    #Put changed fields in a formatted hash for the email
    diff_fields = course.changed_fields.split("|")
    notify_fields = Hash.new

    #Fields professors get notified about
    #'cancelled' is added to changed fields when course is cancelled but not readded during update
    important_fields = ["building", "room", "start_time", "end_time", "days", "descrip", "dean_consent",
                        "instruct_consent", "status", "cancelled", "prof_desc", "which_desc", "prof_note", "display_prof_note"]
    diff_fields.each do |f|
      next if !important_fields.include?(f)
      case f
      when "building", "room"
        notify_fields["Location"] = "#{course.building} #{course.room}"
      when "start_time", "end_time", "days"
        notify_fields["Time"] = "#{course.days}: #{course.start_time.strftime("%I:%M %p")} - #{course.end_time.strftime("%I:%M %p")}"
      when "status", "cancelled"
        case course.status
        when "cancelled"
          notify_fields["Status"] = "Cancelled"
        when "hidden"
          notify_fields["Status"] = "Hidden from search"
        else
          notify_fields["Status"] = "Course displaying as normal (not hidden or cancelled)"
        end
      when "descrip"
        notify_fields["Course description from CIT"] = course.descrip
      when "prof_desc"
        notify_fields["Course description from faculty"] = course.prof_desc
      when "which_desc"
        case course.which_desc
        when "both"
          notify_fields["Displayed description"] = "Displaying both discription from CIT and discription from faculty"
        when "professor"
          notify_fields["Displayed description"] = "Displaying discription from faculty"
        else
          notify_fields["Displayed description"] = "Displaying description from CIT"
        end
      when "prof_note"
        notify_fields["Faculty note"] = course.prof_note unless course.prof_note.blank?
        notify_fields["Faculty note"] = "Note has been removed" if course.prof_note.blank?
      when "display_prof_note"
        notify_fields["Faculty note status"] = course.display_prof_note ? "Displayed" : "Hidden"
      when "dean_consent", "instruct_consent"
        if diff_fields.include?(dean_consent) && diff_fields.include?(instruct_consent)
          notify_fields["Consent"] = "Requires both consent of dean and consent of instructor"
        elsif diff_fields.include?(dean_consent)
          notify_fields["Consent"] = "Requires consent of instructor"
        else
          notify_fields["Consent"] = "Requires consent of dean"
        end
      else
        next
      end
    end

    @fields = notify_fields
    @course = course
    mail(to: email,
         from: "info@oprestissimo.com",
         subject: "#{course.dept} #{course.cnum} has been updated in the Prestissimo database")
  end
end
