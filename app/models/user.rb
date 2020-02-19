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
#  lname           :string(255)
#  role            :string(255)
#  nickname        :string(255)
#  admin           :boolean(1)      default(FALSE)
#  year            :string(255)
#  privacy_prefs   :text
#  major           :string(255)
#  notes           :text
#  cart_id         :integer(4)
#  credits_done    :integer(4)
#  double_major    :string(255)

class User < ApplicationRecord

  #These attributes are changeable via update_attributes
  attr_accessible :second_major,  :major,  :email, :fname,
    :nickname, :year, :notes, :privacy_prefs

  # Means that a user can create reports
  has_many :reports
  # A user can also be reported, however
  has_many :reports, as: :reportable

  #Uses BCrypt gem to encrypt user password
  #has_secure_password

  #Make sure certain fields are in the correct format
  before_save do |user|
    user.email = email.downcase
    user.privacy_prefs = "" if user.privacy_prefs.nil?
  end

  before_save :create_remember_token

  belongs_to :cart

  second_major = "AAST"

  #Give the user a nonce and an empty course list when they are first created
  before_create do |u|
   # u.create_nonce
    u.create_cart
#    u.create_major_cart
  end

  #Ensure the password is at least 6 characters long and the email is of the correct form
  #validates :password, presence: true, length: { minimum: 6 }, :if => :password_digest_changed?
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL },
    uniqueness: { case_sensitive: false }

  #Creates a nonce for a user
  #def create_nonce
  #  # create the nonce
  #  self.nonce = Digest::MD5.hexdigest(Random.new.rand(10000000).to_s + self.email)
  #  # set the expiration date to 24 hours from now
  #  self.nonce_expiry = DateTime.current() + 1.day
  #end

  #Checks if a given nonce is expired
  #def nonce_active?
  #  active = self.nonce_expiry.future?
  #  # the nonce is expired, so need to set it to nil
  #  if !active
  #    self.nonce = nil
  #    # also need to set the expiration to some silly time
  #    self.nonce_expiry = DateTime.now + 10.years
  #    self.save
  #  end
  #  active
  #end

  # make the nonce go bye-bye
  #def nonce_complete
  #  self.nonce = nil
  #  self.nonce_expiry = DateTime.new(0)
  #  self.save
  #end

  # give the key for locating the user's handle
  def handlekey
    Digest::MD5.hexdigest(self.email)
  end

  def make_admin
    self.admin = true
    self.save
  end

  def unmake_admin
    self.admin = false
    self.save
  end 

  def create_cart
    c = Cart.new
    c.courses = ""
    c.save
    self.cart = c
  end

  private

  #Associate a unique string with a user (for session purposes)
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
