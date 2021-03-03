require 'rails_helper'
=begin

RSpec.describe "コメント投稿機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @post = FactoryBot.create(:post)
    @comment = FactoryBot.build(:comment)
  end

  # bundle exec bin/rspec spec/system/posts_spec.rb

  context 'コメント投稿が出来るとき' do
    it 'ログインをしてスレッドに遷移すればコメント投稿が出来る' do
      # トップページに移動する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインする
      sign_in(@user)
      # 投稿するボタンがあることを確認する
      expect(page).to have_content('投稿する')
      # スレッドがあることを確認する
      expect(page).to have_content(@post.text)
      # 投稿詳細ページに遷移する
      visit post_path(@post)
      # 投稿詳細の文字があることを確認する
      expect(page).to have_content('投稿詳細')
      # コメント内容を入力する
      fill_in 'comment_text', with: @comment.text
      # 送信ボタンを押すとCommentモデルのカウントが1上がることを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Comment.count }.by(1)
      # コメントした内容が表示されていることを確認する
      # binding.pry
      expect(page).to have_content(@comment.text)
    end
  end

  context 'コメント投稿が出来ないとき' do
    it 'ログインしていないとコメント投稿フォームが表示されない' do
      # トップページに遷移する
      visit root_path
      # トップページにログインボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインする
      sign_in(@user)
      # 投稿するボタンがあることを確認する
      expect(page).to have_content('投稿する')
      # スレッドがあることを確認する
      expect(page).to have_content(@post.text)
      # 投稿詳細ページに遷移する
      visit post_path(@post)
      # 投稿詳細の文字があることを確認する
      expect(page).to have_content('投稿詳細')
      # コメント投稿フォームがないことを確認する
      expect(page).to have_no_content("コメントを入力")
      expect(page).to have_no_content('送信')
      # expect(page).to have_field("some_field_name", placeholder: "Some Placeholder")
    end

    it '正しい内容を入力しないとコメント投稿が出来ない' do
      # トップページに遷移する
      visit root_path
      # ログインする
      sign_in(@user)
      # 投稿するボタンがあることを確認する
      expect(page).to have_content('投稿する')
      # スレッドがあることを確認する
      expect(page).to have_content(@post.text)
      # 投稿詳細ページに遷移する
      visit post_path(@post)
      # 投稿詳細の文字があることを確認する
      expect(page).to have_content('投稿詳細')
      # 空のコメント内容を入力する
      fill_in 'comment_text', with: ""
      # 送信ボタンを押してもCommentモデルのカウントが上がらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Comment.count }.by(0)
      # 「コメントを（140文字以内で）入力してください。」のエラーメッセージが表示されていることを確認する
      expect(page).to have_content('コメントを（140文字以内で）入力してください。')
      # 次は300文字以上のコメントを入力する
      fill_in 'comment_text', with: "abcde123456"*300
      # 投稿ボタンを押してもPostモデルのカウントが上がらないことを確認する
      expect {
        find('input[name="commit"]').click
      }.to change { Comment.count }.by(0)
      # 「コメントを（140文字以内で）入力してください。」のエラーメッセージが表示されていることを確認する
      expect(page).to have_content('コメントを（140文字以内で）入力してください。')
    end
  end
end


  describe "コメント編集機能", type: :system do
    before do
      @user = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @post = FactoryBot.create(:post)
      @comment = FactoryBot.create(:comment) ### createにするとその時点でトップページに作られている
    end

    context 'コメントの編集が出来る時' do
      it 'ログインしていれば編集が出来る' do
        # トップページに遷移する
        visit root_path
        # ログインする
        sign_in(@user)
        # 投稿するボタンがあることを確認する
        expect(page).to have_content('投稿する')
        # スレッドがあることを確認する
        expect(page).to have_content(@post.text)
        # 投稿詳細ページに遷移する
        visit post_path(@post)
        # 投稿詳細の文字があることを確認する
        expect(page).to have_content('投稿詳細')
        # コメント内容を入力する
        fill_in 'comment_text', with: @comment.text
        # 送信ボタンを押すとCommentモデルのカウントが1上がることを確認する
        expect {
          find('input[name="commit"]').click
        }.to change { Comment.count }.by(1)
        # コメントした内容が表示されていることを確認する
        # binding.pry
        expect(page).to have_content(@comment.text)
        # コメントした内容に編集のリンクがあることを確認する
        expect(page).to have_link '編集'
        # 編集リンクをクリックする
        click_link '編集'
        # コメント編集ページに遷移したことを確認する
        # binding.pry
        expect(current_path).to eq "/posts/#{@post.id}/comments/#{@comment.id+1}/edit"
        # expect(current_path).to eq edit_post_comment_path(@post.comments)
        # コメントした内容が表示されていることを確認する
        expect(page).to have_content(@comment.text)
        # コメント内容を編集する
        edit_comment = "編集しました！"
        fill_in "comment_text", with: edit_comment
        # 送信ボタンを押してもCommentモデルのカウントが上がらないことを確認する
        expect {
          find('input[name="commit"]').click
        }.to change { Comment.count }.by(0)
        # コメントが編集した内容に変更されていることを確認する
        expect(page).to have_content(edit_comment)
      end
    end

    context 'コメントの編集が出来ない時' do
      it 'ログインしていないとコメントの編集が出来ない' do
        # トップページに遷移する
        visit root_path
        # ログインする
        sign_in(@user)
        # 投稿するボタンがあることを確認する
        expect(page).to have_content('投稿する')
        # スレッドがあることを確認する
        expect(page).to have_content(@post.text)
        # 投稿詳細ページに遷移する
        visit post_path(@post)
        # 投稿詳細の文字があることを確認する
        expect(page).to have_content('投稿詳細')
        # コメント内容を入力する
        fill_in 'comment_text', with: @comment.text
        # 送信ボタンを押すとCommentモデルのカウントが1上がることを確認する
        expect {
          find('input[name="commit"]').click
        }.to change { Comment.count }.by(1)
        # コメントした内容が表示されていることを確認する
        expect(page).to have_content(@comment.text)
        # コメントした内容に編集のリンクがあることを確認する
        expect(page).to have_link '編集'
        # ログアウトする
        click_link 'ログアウト'
        # 新規登録とログインのボタンが表示されていることを確認する
        expect(page).to have_content('新規登録')
        expect(page).to have_content('ログイン')
        # スレッドがあることを確認する
        expect(page).to have_content(@post.text)
        # 投稿詳細ページに遷移する
        visit post_path(@post)
        # 投稿詳細の文字があることを確認する
        expect(page).to have_content('投稿詳細')
        # コメントした内容が表示されていることを確認する
        expect(page).to have_content(@comment.text)
        # コメントした内容に編集のリンクがないことを確認する
        expect(page).to have_no_link '編集'
      end

      it '自分のコメント以外は編集が出来ない' do
        # トップページに遷移する
        visit root_path
        # ログインする
        sign_in(@user)
        # 投稿するボタンがあることを確認する
        expect(page).to have_content('投稿する')
        # スレッドがあることを確認する
        expect(page).to have_content(@post.text)
        # 投稿詳細ページに遷移する
        visit post_path(@post)
        # 投稿詳細の文字があることを確認する
        expect(page).to have_content('投稿詳細')
        # コメント内容を入力する
        fill_in 'comment_text', with: @comment.text
        # 送信ボタンを押すとCommentモデルのカウントが1上がることを確認する
        expect {
          find('input[name="commit"]').click
        }.to change { Comment.count }.by(1)
        # コメントした内容が表示されていることを確認する
        expect(page).to have_content(@comment.text)
        # コメントした内容に編集のリンクがあることを確認する
        expect(page).to have_link '編集'
        # ログアウトする
        click_link 'ログアウト'
        # コメントしたユーザーとは別のユーザーでログインする
        sign_in(@user2)
        # 投稿するとログアウトの文字が表示されていることを確認する
        expect(page).to have_content('投稿する')
        expect(page).to have_content('ログアウト')
        # スレッドがあることを確認する
        expect(page).to have_content(@post.text)
        # 投稿詳細ページに遷移する
        visit post_path(@post)
        # 投稿詳細の文字があることを確認する
        expect(page).to have_content('投稿詳細')
        # コメントした内容が表示されていることを確認する
        expect(page).to have_content(@comment.text)
        # コメントした内容に編集のリンクがないことを確認する
        expect(page).to have_no_link '編集'
      end
    end
  end
=end

  # end
