class Group < ActiveRecord::Base
  validates :name, :description, presence: true
  has_many :posts, -> { order "created_at DESC" }
  belongs_to :admin, foreign_key: 'user_id', class_name: 'User'
end
