crumb :root do
  link "Home", root_path
end

crumb :category_index do
  link "カテゴリーから探す", categories_path
end

crumb :parent_category do |category|
  category = Category.find(params[:id]).root
  link "#{category.name}", category_path(category)
  parent :category_index
end

crumb :child_category do |category|
  category = Category.find(params[:id])
  link "#{category.name}", category_path(category)
  parent :parent_category
end