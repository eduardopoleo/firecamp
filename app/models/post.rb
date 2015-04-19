class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  validates :content, presence: true, length: { minimum: 2 }
  has_many :groups, through: :group_posts
end
