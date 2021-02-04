class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :text, presence: true, length: { maximum: 140 }
end
