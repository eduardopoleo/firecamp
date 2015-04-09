class Group < ActiveRecord::Base
  validates :name, :description, presence: true

  has_many :invitation_groups
  has_many :invitations, through: :invitation_groups
  
  has_many :user_groups
  has_many :users, through: :user_groups

  has_many :group_posts
  has_many :posts, through: :group_posts

  has_many :group_guides
  has_many :guides, through: :group_guides
end
