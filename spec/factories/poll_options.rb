FactoryBot.define do
  factory :poll_option do
    association :poll
    content { "選択肢の内容" }
  end
end
