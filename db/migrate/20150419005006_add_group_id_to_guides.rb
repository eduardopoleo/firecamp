class AddGroupIdToGuides < ActiveRecord::Migration
  def change
    add_column :guides, :group_id, :integer
  end
end
