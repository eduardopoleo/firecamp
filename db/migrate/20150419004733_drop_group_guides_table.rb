class DropGroupGuidesTable < ActiveRecord::Migration
  def up
    drop_table :group_guides
  end

  def down
    create_table :group_guides do |t|
      t.integer :group_id, :guide_id
      t.timestamps
    end
  end
end
