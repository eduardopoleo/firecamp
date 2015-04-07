class AddContentColumnToGuides < ActiveRecord::Migration
  def change
    add_column :guides, :content, :text
  end
end
