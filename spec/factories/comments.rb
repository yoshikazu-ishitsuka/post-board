FactoryBot.define do
  factory :comment do
    text { "コメント投稿" }
    association :user
    association :post
  end
end
