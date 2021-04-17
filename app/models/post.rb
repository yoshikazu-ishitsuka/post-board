class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tag_relations
  has_many :tags, through: :post_tag_relations

  validates :text, presence: true, length: { maximum: 300 }
end
