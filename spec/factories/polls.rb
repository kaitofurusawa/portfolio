FactoryBot.define do
  factory :poll do
    association :board
    question { "テスト" }

    after(:build) do |poll|
      if poll.poll_options.empty?
        poll.poll_options.build(content: "A")
        poll.poll_options.build(content: "B")
      end
    end
  end
end
