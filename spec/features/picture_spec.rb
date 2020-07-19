require 'rails_helper'
feature 'Picture', type: :feature do
  let(:user) { create(:user) }

  scenario '非ログイン時に新規投稿ページに移動' do
    visit new_picture_path
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content('ログインが必要です')
  end

  scenario '写真の新規投稿' do
    category = create(:category, ancestry: nil)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
    visit new_picture_path
    expect(current_path).to eq new_picture_path
    expect do
      attach_file 'picture_image', "#{Rails.root}/spec/fixtures/test.jpg"
      select category.name, from: 'category-select'
      click_button '投稿する'
      expect(current_path).to eq root_path
    end.to change(Picture, :count).by(1)
  end

  scenario '投稿の削除' do
    create(:category, id: 1, ancestry: nil)
    category = create(:category, ancestry: "1")
    picture = create(:picture, user: user, category: category)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
    expect do
      visit picture_path(picture)
      click_link '投稿削除'
      expect(current_path).to eq root_path
      expect(page).to have_content('写真を削除しました')
    end.to change(Picture, :count).by(-1)
  end
end