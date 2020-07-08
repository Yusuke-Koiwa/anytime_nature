crumb :root do
  link "Home", root_path
end

crumb :user do |user|
  user = User.find(params[:id])
  if user == current_user
    link "マイページ", user_path(user)
  else
    link "#{user.name}", user_path(user)
  end
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