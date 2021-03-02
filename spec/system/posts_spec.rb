require 'rails_helper'
# =begin

RSpec.describe "新規投稿機能", type: :system do
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
# =end

  describe "投稿編集機能", type: :system do
    before do
      @user = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @post = FactoryBot.create(:post)
    end

    context '投稿の編集が出来る時' do
      it 'ログインして新規投稿をすれば編集が出来る' do
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
        # 投稿内容を入力する
        post = @post.text
        # id = @post.id
        fill_in 'post_text', with: post
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
        # 投稿したスレッドに編集ボタンがあることを確認する
        expect(page).to have_content('編集')
        # 編集ボタンクリックする
        click_link '編集'
        # 投稿編集ページへ遷移したことを確認する
        # binding.pry
        expect(current_path).to eq edit_post_path(@user.posts.ids)
        # 投稿編集の文字があることを確認する
        expect(page).to have_content('投稿編集')
        # 投稿した内容が表示されていることを確認する
        expect(page).to have_content(post)
        # 投稿内容を編集する
        edit_post = "編集しました！"
        fill_in 'post_text', with: edit_post
        # 編集ボタンを押してもPostモデルのカウントが上がらないことを確認する
        expect {
          find('input[name="commit"]').click
        }.to change { Post.count }.by(0)
        # トップページに遷移したことを確認する
        expect(current_path).to eq "/posts"
        # 投稿内容が編集した内容に変更されていることを確認する
        expect(page).to have_content(edit_post)
      end
    end

    context '投稿の編集が出来ない時' do
      it 'ログインしていないと投稿の編集が出来ない' do
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
        # 投稿内容を入力する
        post = @post.text
        # id = @post.id
        fill_in 'post_text', with: post
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
        # 投稿したスレッドに編集ボタンがあることを確認する
        expect(page).to have_content('編集')
        # ログアウトする
        click_link 'ログアウト'
        # 新規登録とログインのボタンが表示されていることを確認する
        expect(page).to have_content('新規登録')
        expect(page).to have_content('ログイン')
        # 投稿したスレッドに編集ボタンが無いことを確認する
        expect(page).to have_no_content('編集')
      end

      it '自分の投稿以外は編集が出来ない' do
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
        # 投稿内容を入力する
        post = @post.text
        # id = @post.id
        fill_in 'post_text', with: post
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
        # 投稿したスレッドに編集ボタンがあることを確認する
        expect(page).to have_content('編集')
        # ログアウトする
        click_link 'ログアウト'
        # 新規登録とログインのボタンが表示されていることを確認する
        expect(page).to have_content('新規登録')
        expect(page).to have_content('ログイン')
        # 投稿したスレッドに編集ボタンが無いことを確認する
        expect(page).to have_no_content('編集')
        # 投稿したユーザーとは別のユーザーでログインする
        sign_in(@user2)
        # 編集ボタンが無いことを確認する
        expect(page).to have_no_content('編集')
      end
    end
  end

end
