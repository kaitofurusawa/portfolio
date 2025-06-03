FactoryBot.define do
  factory :poll_option do
    content { "MyString" }
    poll { nil }
  end
end
