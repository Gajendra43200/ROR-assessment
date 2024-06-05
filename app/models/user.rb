class User < ApplicationRecord
  has_secure_password
  before_create :generate_otp_secret
  validates :user_type, inclusion: { in: %w[Author Reader] }
  validates :email, presence: true, uniqueness: true
  has_many :blogs
  has_many :posts
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def generate_otp_secret
    self.otp_secret = ROTP::Base32.random_base32
  end

  def verify_otp(code)
    totp = ROTP::TOTP.new(otp_secret)
    totp.verify(code)
  end

  def otp_provisioning_uri(account = email, issuer = 'BlogPost Management')
    totp = ROTP::TOTP.new(otp_secret, issuer:)
    totp.provisioning_uri(account)
  end
end
