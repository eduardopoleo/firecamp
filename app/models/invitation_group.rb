class InvitationGroup < ActiveRecord::Base
  belongs_to :invitation
  belongs_to :group
end
