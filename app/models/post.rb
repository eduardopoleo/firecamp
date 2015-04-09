class Post < ActiveRecord::Base
  belongs_to :user
  validates :content, presence: true, length: { minimum: 2 }
  validates_presence_of :groups

  has_many :group_posts
  has_many :groups, through: :group_posts
end
