class AddCommentsCountToPictures < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :comments_count, :integer, default: 0, null: false
  end
end