FactoryBot.define do
  factory :board do
    association :user
    title { "テストタイトル" }
    content { "テスト本文" }
    # thumbnail_url は通常不要。必要なら追加。
    after(:build) do |board|
      # sample.jpg はテスト用画像として必須。なければコメントアウトでOK。
      board.image.attach(
        io: File.open(Rails.root.join('spec/fixtures/sample.jpg')),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
