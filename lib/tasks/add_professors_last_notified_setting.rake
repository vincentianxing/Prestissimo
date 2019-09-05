namespace :db do
  desc 'add professors last notified time setting'
  task add_profs_last_notified: :environment do
    s = Setting.new
    s.key = "profs_last_notified"
    s.value = ""
    if s.save
      puts "Setting #{s.key} set to #{s.value}"
    end
  end
end
