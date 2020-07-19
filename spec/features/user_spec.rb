require 'rails_helper'
feature 'User', type: :feature do
  let(:user) { create(:user) }

  scenario '非ログイン時の表示' do
    visit root_path
    expect(page).to have_no_content('マイページ')
  end

  scenario 'ログインの実行' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
    expect(current_path).to eq root_path
    expect(page).to have_content('マイページ')
  end

  scenario 'ログアウトの実行' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
    expect(current_path).to eq root_path
    expect(page).to have_content('マイページ')
    click_link 'ログアウト'
    expect(current_path).to eq root_path
    expect(page).to have_no_content('マイページ')
  end

  scenario '新規アカウント登録' do
    visit new_user_registration_path
    expect do
      fill_in 'user_name', with: 'new_user'
      fill_in 'user_email', with: 'new@test.com'
      fill_in 'user_password', with: '1234567'
      fill_in 'user_password_confirmation', with: '1234567'
      attach_file 'user_image', "#{Rails.root}/spec/fixtures/test.jpg"
      click_button 'アカウント作成'
      expect(current_path).to eq root_path
    end.to change(User, :count).by(1)
  end

  scenario 'アカウント情報の更新' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'ログイン'
    click_link 'マイページ'
    expect(current_path).to eq user_path(user)
    find('.user-edit-btn').click
    expect(current_path).to eq edit_user_path(user)
    fill_in 'user_name', with: 'new_name'
    click_button 'アカウント更新'
    expect(current_path).to eq user_path(user)
    expect(page).to have_content('変更を保存しました')
    expect(page).to have_content('new_name')
  end
end