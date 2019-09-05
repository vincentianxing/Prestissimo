# find users w/ expired nonce in database
# if their account is active, make the nonce nil and the nonce_expiry 0
# if account is pending, delete the account

namespace :db do
  desc "remove expired user accounts"
  task filter_users: :environment do
  end

  desc "Expire all remember_tokens"
  task expire_tokens: :environment do
    User.all.each do |user|
      # before a user is saved it gets a new remember_token
      user.save
    end
  end

  desc "Notify professors of course updates"
  task notify_profs: :environment do
    # Find courses where professors want to be notified
    course_arr=[]
    Course.all(:conditions=>"notify_profs IS NOT NULL AND notify_profs != ''").each do |c|
      if course_arr.include?(c.semcrn)
        c.recent_edit=""
        c.changed_fields=""
        c.save
        next
      end

      course_arr<<c.semcrn

      next if c.changed_fields.blank?

      #Don't send if fields changed aren't important 
      important_fields=["building","room","start_time","end_time","days",
        "descrip","dean_consent","instruct_consent","status","cancelled",
        "prof_desc","which_desc","prof_note","display_prof_note"]
      changed_fields_arr=c.changed_fields.split("|")
      dup_arr = important_fields + changed_fields_arr
      if dup_arr.uniq.length == dup_arr.length
        c.recent_edit=""
        c.changed_fields=""
        c.save
        next
      end
      
      prof_emails = c.notify_profs.split("|")
      prof_emails.each do |prof|
        next if c.recent_edit == prof
        puts "#{prof} is being notified about #{c.semcrn}."
        Interact.notify_professor(c, prof).deliver  
      end
      c.recent_edit=""
      c.changed_fields=""
      c.save
    end
  end

end
