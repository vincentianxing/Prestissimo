# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Setting.find_or_create_by(key: :current_semester) do |setting|
  setting.value ||= "Fall 2012"
end

Setting.find_or_create_by(key: :semesters) do |setting|
  setting.value ||= "Fall 2012"
end

Setting.find_or_create_by(key: :courses_last_updated) do |setting|
  setting.value ||= "2000-01-01T01:01:01-0400"
end

Setting.find_or_create_by(key: :motd) do |setting|
  setting.value ||= "Welcome to Oprestissimo"
end