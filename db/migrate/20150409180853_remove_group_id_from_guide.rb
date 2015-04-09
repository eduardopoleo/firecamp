class RemoveGroupIdFromGuide < ActiveRecord::Migration
  def up
    remove_column :guides, :group_id
  end

  def down
    add_column :guides, :group_id, :integer
  end
end
