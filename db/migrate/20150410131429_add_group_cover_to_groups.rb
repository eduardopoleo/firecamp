class AddGroupCoverToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :group_cover, :string
  end
end
