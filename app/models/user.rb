class User < ActiveRecord::Base
  validates :email, :full_name, :password, presence: true
  validates :email, uniqueness: true
  has_secure_password validations: false

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
