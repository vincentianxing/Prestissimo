require 'spec_helper'

describe Professor do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: professors
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  email      :string(255)
#  fname      :string(255)
#  lname      :string(255)
#  nickname   :string(255)
#  status     :string(255)     default("active")
#  office     :string(255)
#  phone      :string(255)
#  contact    :string(255)
#  url        :string(255)
#  content    :text
#

