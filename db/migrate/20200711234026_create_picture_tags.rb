class CreatePictureTags < ActiveRecord::Migration[5.2]
  def change
    create_table :picture_tags do |t|
      t.integer :picture_id
      t.integer :tag_id
      t.timestamps
    end
    add_index :picture_tags, :picture_id
    add_index :picture_tags, :tag_id
    add_index :picture_tags, [:picture_id, :tag_id], unique: true
  end
end
