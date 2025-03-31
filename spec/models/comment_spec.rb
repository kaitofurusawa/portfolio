require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "有効なコメントで保存できる" do
    expect(build(:comment)).to be_valid
  end

  it "本文が空だと無効" do
    comment = build(:comment, content: "")
    expect(comment).not_to be_valid
  end

  it "本文が1000文字を超えると無効" do
    comment = build(:comment, content: "a" * 1001)
    expect(comment).not_to be_valid
  end
end