FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    name { "Test User" }
    provider { nil }
    uid { nil }
  end
end
