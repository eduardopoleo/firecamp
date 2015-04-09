class Guide < ActiveRecord::Base
  belongs_to :admin, foreign_key: 'user_id', class_name: 'User'

  validates :content, presence: true, length: { minimum: 5 }
  validates :title, presence: true, length: { minimum: 2 }

  has_many :group_guides
  has_many :groups, through: :group_guides
end
