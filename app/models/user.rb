class User < ActiveRecord::Base
  validates :email, :full_name, :password, presence: true
  validates :email, uniqueness: true

  has_many :user_groups
  has_many :groups, through: :user_groups

  has_many :posts
  has_many :guides

  has_secure_password validations: false
  before_create :generate_token

  mount_uploader :avatar, AvatarUploader

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
