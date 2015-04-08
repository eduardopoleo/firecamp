class Group < ActiveRecord::Base
  validates :name, :description, presence: true
  has_many :posts, -> { order "created_at DESC" }
  has_many :guides, -> { order "created_at DESC" }
  has_many :invitation_group
  has_many :invitations, through: :invitation_group

  belongs_to :admin, foreign_key: 'user_id', class_name: 'User'
end
