require 'rails_helper'

RSpec.describe Board, type: :model do
  it "有効な掲示板情報で保存できる" do
    expect(build(:board)).to be_valid
  end

  it "タイトルが空だと無効" do
    board = build(:board, title: "")
    expect(board).not_to be_valid
  end

  it "タイトルが50文字を超えると無効" do
    board = build(:board, title: "a" * 51)
    expect(board).not_to be_valid
  end

  it "本文が空だと無効" do
    board = build(:board, content: "")
    expect(board).not_to be_valid
  end

  it "本文が500文字を超えると無効" do
    board = build(:board, content: "a" * 501)
    expect(board).not_to be_valid
  end

  it "画像が未添付でも保存できる" do
    board = build(:board)
    board.image.purge # 画像を削除
    expect(board).to be_valid
  end

  it "画像サイズが5MB超えると無効" do
    board = build(:board)
    board.image.attach(
      io: StringIO.new("a" * (5.megabytes + 1)),
      filename: "big.png",
      content_type: "image/png"
    )
    expect(board).not_to be_valid
  end

  it "画像のコンテンツタイプが無効だと無効" do
    board = build(:board)
    board.image.attach(
      io: StringIO.new("image content"),
      filename: "invalid.bmp",
      content_type: "image/bmp"
    )
    expect(board).not_to be_valid
  end
end
