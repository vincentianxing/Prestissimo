require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  fname          :string(255)
#  email          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  remember_token :string(255)
#  status         :string(255)      default("pending")
#  lname          :string(255)
#  role           :string(255)
#  nickname       :string(255)
#  admin          :boolean          default("0")
#  year           :string(255)
#  notes          :text(65535)
#  privacy_prefs  :text(65535)
#  cart_id        :integer
#  second_major   :string(255)
#  double_major   :string(255)
#  major          :string(255)
#  prof_id        :integer
#

