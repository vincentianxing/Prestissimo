# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  key        :string(255)
#  value      :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Setting < ApplicationRecord
  def self.get_val(key)
    Setting.find_by_key(key).value
  end

  def self.set(key, value)
    s = Setting.find_by_key(key)
    s.value = value
    s.save
    s
  end
end
