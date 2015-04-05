class Group < ActiveRecord::Base
  validates :name, :description, presence: true
  belongs_to :admin, foreign_key: 'user_id', class_name: 'User'
end
