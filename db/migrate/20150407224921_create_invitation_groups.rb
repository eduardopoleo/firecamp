class CreateInvitationGroups < ActiveRecord::Migration
  def change
    create_table :invitation_groups do |t|
      t.integer :group_id, :invitation_id
      t.timestamps
    end
  end
end
