class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :title
      t.text :description
      t.string :category
      t.integer :user_id, :group_id
      t.timestamps
    end
  end
end
