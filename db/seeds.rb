100.times do |i|
  board = Board.new(
    title: "サンプル投稿 #{i + 1}",
    content: "これはサンプルの本文です #{i + 1}。",
    user: User.first
  )

  unless board.save
    puts "エラー (#{i + 1} 件目): #{board.errors.full_messages.join(", ")}"
  end
end
