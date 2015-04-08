class Invitation < ActiveRecord::Base
  has_many :invitation_group
  has_many :groups, through: :invitation_group
  validates_presence_of :groups

  validates :email, presence: true

  def add_groups_to_new_user(user)
    groups.each do |group|
      user.groups << group
    end
    update_attribute(:token, nil)
  end
end
