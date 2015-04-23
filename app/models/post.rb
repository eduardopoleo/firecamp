class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :votes, as: :voteable
  validates :content, presence: true, length: { minimum: 2 }
end
