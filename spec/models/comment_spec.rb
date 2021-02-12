require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @comment = FactoryBot.build(:comment)
  end

  describe '掲示板投稿機能' do
    context 'commentが登録出来るとき' do
      it 'textが存在すれば登録出来ること' do
        expect(@comment).to be_valid
      end

      it 'textが140文字以内なら登録出来ること' do
        @comment.text = 'あ'*140
        expect(@comment).to be_valid
      end
    end

    context 'commentが登録出来ないとき' do
      it 'textが空なら登録出来ない' do
        @comment.text = nil
        @comment.valid?
        expect(@comment.errors.full_messages).to include('コメントを入力してください')
      end

      it 'textが140文字を超えると登録出来ない' do
        @comment.text = 'あ' * 141
        @comment.valid?
        expect(@comment.errors.full_messages).to include('コメントは140文字以内で入力してください')
      end
    end

  end
end