class DropGroupPostTable < ActiveRecord::Migration
  def up
    drop_table :group_posts
  end

  def down
    create_table :group_posts do |t|
      t.integer :group_id
      t.integer :post_id
      t.timestamps
    end
  end
end
