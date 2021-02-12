class User < ApplicationRecord
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,32}+\z/i

  validates :name, presence: true, length: { maximum: 20 }

  validates :email,
    presence: true,
    format: { with: VALID_EMAIL_REGEX, allow_blank: true },
    uniqueness: true
  
  validates :password,
    presence: true,
    confirmation: true,
    format: { with: VALID_PASSWORD_REGEX, message: :invalid_password, allow_blank: true }


  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end
end
