class Category < ApplicationRecord
  has_many :pictures
  has_ancestry

  def set_pictures
    if self.root?
      start_id = self.children.first.id
      end_id = self.children.last.id
      Picture.where(category_id: start_id..end_id)
    else
      self.pictures
    end
  end
end