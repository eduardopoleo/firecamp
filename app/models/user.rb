class User < ActiveRecord::Base
  validates :email, :full_name, :password, presence: true
  validates :email, uniqueness: true
  has_secure_password validations: false

  has_many :user_groups
  has_many :groups, through: :user_groups
  mount_uploader :avatar, AvatarUploader

  has_many :posts
  has_many :guides

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

  def has_membership?(object)
    is_member = false
    groups.each do |group|
      is_member =  true if object.groups.include?(group) 
    end
    is_member
  end
end
