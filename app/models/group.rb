class Group < ActiveRecord::Base
  validates :name, :description, presence: true
  has_many :posts, -> { order "created_at DESC" }
  has_many :guides, -> { order "created_at DESC" }
  has_many :invitation_groups
  has_many :invitations, through: :invitation_groups
  
  has_many :user_groups
  has_many :users, through: :user_groups
end
