FactoryBot.define do
  factory :post do
    text { "スレッド投稿" }
    association :user
  end
end
