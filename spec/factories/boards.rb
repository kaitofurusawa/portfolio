FactoryBot.define do
  factory :board do
    association :user
    title { "テストタイトル" }
    content { "テスト本文" }
    after(:build) do |board|
      board.image.attach(
        io: File.open(Rails.root.join('spec/fixtures/sample.jpg')),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
