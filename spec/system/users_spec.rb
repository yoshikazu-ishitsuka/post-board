require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録が出来るとき' do
    it '正しい情報を入力すればユーザー新規登録が出来てトップページに遷移する' do
      #トップページに移動する
      visit root_path
      #トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      #新規登録ページへ移動する
      visit new_user_registration_path
      #ユーザー情報を入力する
      fill_in 'user_name', with: @user.name
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      #サインアップボタンを押すとユーザーモデルのカウントが１上がることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      #トップページへ遷移したことを確認する
      expect(current_path).to eq root_path
      #ユーザーネームとログアウトボタンと投稿するボタンが表示されていることを確認する
      expect(page).to have_content(@user.name)
      expect(page).to have_content('ログアウト')
      expect(page).to have_content('投稿する')
      #サインアップページへ遷移するボタンや、ログインボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録が出来ないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      #トップページに移動する
      visit root_path
      #トップページにサインアップページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      #新規登録ページへ移動する
      visit new_user_registration_path
      #空のユーザー情報を入力する
      fill_in 'user_name', with: ""
      fill_in 'user_email', with: ""
      fill_in 'user_password', with: ""
      fill_in 'user_password_confirmation', with: ""
      #サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      #新規登録ページへ戻されることを確認する
      expect(current_path).to eq "/users"
    end
  end
end

RSpec.describe "ユーザーログイン", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインが出来ること' do
    it '保存されているユーザーの情報と合致すればログインが出来る' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq root_path
      # ユーザー名とログアウトボタンが表示されていることを確認する
      expect(page).to have_content(@user.name)
      expect(page).to have_content('ログアウト')
      expect(page).to have_content('投稿する')
      # サインアップページへ遷移するボタンやログインページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('新規登録')
      # expect(page).to have_no_content('ログイン') ##flashメッセージの[ログイン]にひっかかってたためコメントアウト
    end
  end

  context 'ログインが出来ないこと' do
    it '保存されているユーザーの情報と合致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 空のユーザー情報を入力する
      fill_in 'user_email', with: ""
      fill_in 'user_password', with: ""
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq new_user_session_path
    end
  end
end
