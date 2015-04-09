class CreateGroupGuides < ActiveRecord::Migration
  def change
    create_table :group_guides do |t|
      t.integer :group_id, :guide_id
      t.timestamps
    end
  end
end
