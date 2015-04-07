class Guide < ActiveRecord::Base
  belongs_to :admin, foreign_key: 'user_id', class_name: 'User'
  belongs_to :group

  validates :content, presence: true, length: { minimum: 5 }
  validates :title, presence: true, length: { minimum: 2 }
end
