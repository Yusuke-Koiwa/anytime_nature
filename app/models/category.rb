class Category < ApplicationRecord
  has_many :pictures
  has_ancestry
end