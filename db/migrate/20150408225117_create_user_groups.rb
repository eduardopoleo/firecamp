class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.integer :user_id, :group_id
      t.timestamps
    end
  end
end
