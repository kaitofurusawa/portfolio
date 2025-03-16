10.times do |i|
  Board.create!(
    title: "掲示板 #{i + 1}",
    thumbnail_url: "sample.jpg"
  )
end

puts "10件の掲示板データを作成しました。"
