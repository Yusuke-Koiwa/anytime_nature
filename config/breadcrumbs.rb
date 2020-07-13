crumb :root do
  link "Home", root_path
end

crumb :show do
  picture = Picture.find(params[:id])
  link "写真", "#"
end

crumb :user do |user|
  user = User.find(params[:id])
  link "#{user.name}", user_path(user)
end

crumb :mypage do
  link "マイページ", user_path(current_user)
end

crumb :favorite do
  link "お気に入り", favorite_users_path
  parent :mypage
end

crumb :follow do |user|
  user = User.find(params[:id])
  link "フォロー", following_user_path(user)
  if user == current_user
    parent :mypage
  else
    parent :user
  end
end

crumb :follower do |user|
  user = User.find(params[:id])
  link "フォロワー", follower_user_path(user)
  if user == current_user
    parent :mypage
  else
    parent :user
  end
end

crumb :post_show do |user|
  user = User.find(params[:id])
  link "投稿", "#"
  if user == current_user
    parent :mypage
  else
    parent :user
  end
end

crumb :popular_show do |user|
  user = User.find(params[:id])
  link "人気投稿", "#"
  if user == current_user
    parent :mypage
  else
    parent :user
  end
end

crumb :favorite_show do
  link "写真", "#"
  parent :favorite
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

crumb :category_picture do |category|
  category = Category.find(params[:id])
  link "写真", "#"
  if category.root?
    parent :parent_category
  else
    parent :child_category
  end
end

crumb :tag_show do |tag|
  tag = Tag.find(params[:id])
  link icon('fas', 'tag') +  " #{tag.name}", tag_path(tag)
end