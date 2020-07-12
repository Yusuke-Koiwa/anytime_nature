class RemoveTitleFromPictures < ActiveRecord::Migration[5.2]
  def change
    remove_column :pictures, :title, :string
  end
end