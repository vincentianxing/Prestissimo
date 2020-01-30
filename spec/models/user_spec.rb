cd pr require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: users
#
#  id              :integer(4)      not null, primary key
#  fname           :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  remember_token  :string(255)
#  status          :string(255)     default("pending")
#  nonce           :string(255)
#  lname           :string(255)
#  role            :string(255)
#  nickname        :string(255)
#  admin           :boolean(1)      default(FALSE)
#  gender          :string(255)
#  year            :string(255)
#  nonce_expiry    :datetime
#  privacy_prefs   :text
#  notes           :text
#  cart_id         :integer(4)
#

