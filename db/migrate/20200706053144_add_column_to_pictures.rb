class AddColumnToPictures < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :favorites_count, :integer, default: 0, null: false
  end
end
