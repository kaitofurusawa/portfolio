FactoryBot.define do
  factory :comment do
    association :user
    association :board
    content { "テストコメントです。" }
  end
end
