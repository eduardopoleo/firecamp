class Invitation < ActiveRecord::Base
  has_many :invitation_groups
  has_many :groups, through: :invitation_groups

  validates_presence_of :groups, :email

  def add_groups_to_new_user(user)
    groups.each do |group|
      user.groups << group
    end
    update_attribute(:token, nil)
  end
end
