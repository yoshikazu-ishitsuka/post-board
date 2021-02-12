require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @post = FactoryBot.build(:post)
  end

  describe '掲示板投稿機能' do
    context 'postが登録出来るとき' do
      it 'textが存在すれば登録出来ること' do
        expect(@post).to be_valid
      end

      it 'textが140文字以内なら登録出来ること' do
        @post.text = 'あ'*140
        expect(@post).to be_valid
      end
    end

    context 'postが登録出来ないとき' do
      it 'textが空なら登録出来ない' do
        @post.text = nil
        @post.valid?
        expect(@post.errors.full_messages).to include('投稿内容を入力してください')
      end

      it 'textが140文字を超えると登録出来ない' do
        @post.text = 'あ' * 141
        @post.valid?
        expect(@post.errors.full_messages).to include('投稿内容は140文字以内で入力してください')
      end
    end

  end
end
