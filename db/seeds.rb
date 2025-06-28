require 'faker'

users = User.all
raise "ユーザーがいません" if users.empty?

200.times do
  user = users.sample

  board = user.boards.build(
    title: Faker::Lorem.sentence(word_count: rand(2..8)),
    content: Faker::Lorem.paragraph(sentence_count: rand(2..6))
  )

  # アンケートもランダムで作る
  if rand < 0.6 # 60%ぐらいでアンケートつける
    poll = board.build_poll(question: Faker::Lorem.question)
    rand(2..6).times do
      poll.poll_options.build(content: Faker::Lorem.words(number: rand(1..4)).join(" "))
    end
  end

  board.save!
end
