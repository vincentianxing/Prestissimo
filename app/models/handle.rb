# == Schema Information
#
# Table name: handles
#
#  id         :integer(4)      not null, primary key
#  username   :string(255)
#  is_mute    :boolean(1)      default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  handlekey  :string(255)
#

class Handle < ApplicationRecord
  acts_as_voter

	# A handle can be reported by other users
	has_many :reports, as: :reportable

  #Unless handlekey is non-nil and the username is unique (ignoring case),
  #saving a handle instance will fail and return false.
  validates :handlekey, presence: true
  validates :username, uniqueness: { case_sensitive: false }

  def mute
    self.is_mute = true
  end

  def unmute
    self.is_mute = false
  end
end
