require 'rails_helper'

RSpec.describe "ユーザー投稿機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.build(:post)
  end

  # bundle exec bin/rspec spec/system/posts_spec.rb

  context '新規投稿が出来るとき' do
    it 'ログインすれば新規投稿が出来てトップページに遷移する' do
      # トップページに移動する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインする
      sign_in(@user)
      # 投稿するボタンがあることを確認する
      expect(page).to have_content('投稿する')
      # 新規投稿ページへ遷移する
      visit new_post_path
      # 新規投稿の文字が表示されていることを確認する
      expect(page).to have_content('新規投稿')
      # 投稿内容を入力する
      post = @post.text
      fill_in 'post_text', with: post
      # binding.pry
      # 投稿ボタンを押すとPostモデルのカウントが1上がることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Post.count }.by(1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq root_path
      # 新規投稿の文字が無いことを確認する。投稿一覧の文字が表示されていることを確認する
      expect(page).to have_no_content('新規投稿')
      expect(page).to have_content('投稿一覧')
      # 投稿した内容が表示されていることを確認する
      expect(page).to have_content(post)
    end
  end

  context '新規投稿が出来ないとき' do
    it 'ログインしていないと新規投稿ページに遷移出来ない' do
      # トップページに遷移する
      visit root_path
      # 投稿するボタンが無いことを確認する
      expect(page).to have_no_content('投稿する')
    end

    it '正しい内容を入力しないと新規投稿が出来ない' do
      # トップページに遷移する
      visit root_path
      # ログインする
      sign_in(@user)
      # 投稿するボタンがあることを確認する
      expect(page).to have_content('投稿する')
      # 新規投稿ページへ遷移する
      visit new_post_path
      # 新規投稿の文字が表示されていることを確認する
      expect(page).to have_content('新規投稿')
      # 空の投稿内容を入力する
      fill_in 'post_text', with: ""
      # 投稿ボタンを押してもPostモデルのカウントが上がらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Post.count }.by(0)
      # 「投稿内容を入力してください」のエラーメッセージが表示されていることを確認する
      expect(page).to have_content('投稿内容を入力してください')
      # 次は300文字以上の投稿内容を入力する
      fill_in 'post_text', with: "abcde123456"*300
      # 投稿ボタンを押してもPostモデルのカウントが上がらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Post.count }.by(0)
      # 「投稿内容は300文字以内で入力してください」のエラーメッセージが表示されていることを確認する
      expect(page).to have_content('投稿内容は300文字以内で入力してください')
    end
  end

end
