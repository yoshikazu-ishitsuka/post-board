require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context 'userが登録できるとき' do
      it 'name, email, password, password_confirmationが存在すれば登録出来ること' do
        expect(@user).to be_valid
      end
    end
  
    context 'userが登録できないとき' do 
      it 'nameが空だと登録出来ないこと' do
        @user.name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('名前を入力してください')
      end
      it 'nameが20文字を超えると登録出来ないこと' do
        @user.name = '123'*7
        @user.valid?
        expect(@user.errors.full_messages).to include('名前は20文字以内で入力してください')
      end  
      
      it 'emailが空なら登録できないこと' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('メールアドレスを入力してください')
      end
      it 'emailが無効な値なら登録できないこと' do
        @user.email = "test@com"
        @user.valid?
        expect(@user.errors.full_messages).to include('メールアドレスは不正な値です')
      end
      it 'emailに@が無い場合は登録できないこと' do
        @user.email = "test.mail.com"
        @user.valid?
        expect(@user.errors.full_messages).to include('メールアドレスは不正な値です')
      end
      it 'emailが重複する場合は登録できないこと' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include('メールアドレスはすでに存在します')
      end

      it 'passwordが空なら登録できないこと' do
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
      end
      it 'passwordが7文字以下なら登録できないこと' do
        @user.password = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは8文字以上で入力してください')
      end
      it 'passwordが32文字を超えると登録できないこと' do
        @user.password = '12a'*11
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは32文字以内で入力してください')
      end
      it 'passwordに全角が含まれていると登録できないこと' do
        @user.password = 'あいうえお12345'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは半角英数字・ハイフン・アンダーバーが使えます')
      end
      it 'passwordが数字のみだと登録できないこと' do
        @user.password = '11112222'
        @user.password_confirmation = '11112222'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは半角英数字・ハイフン・アンダーバーが使えます')
      end
      it 'passwordが英字のみだと登録できないこと' do
        @user.password = 'aaaabbbb'
        @user.password_confirmation = 'aaaabbbb'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは半角英数字・ハイフン・アンダーバーが使えます')
      end
      it 'passwordが存在してもpassword_confirmationが空だと登録できないこと' do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
    end

  end
end
