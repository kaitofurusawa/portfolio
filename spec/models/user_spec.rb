require 'rails_helper'

RSpec.describe User, type: :model do
  it "有効なユーザー情報で保存できる" do
    expect(build(:user)).to be_valid
  end

  it "名前が空だと無効" do
    user = build(:user, name: "")
    expect(user).not_to be_valid
  end

  it "名前が30文字を超えると無効" do
    user = build(:user, name: "a" * 31)
    expect(user).not_to be_valid
  end

  it "メールアドレスが空だと無効" do
    user = build(:user, email: "")
    expect(user).not_to be_valid
  end

  it "メールアドレスが重複していると無効" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    expect(user).not_to be_valid
  end

  it "メールアドレスが255文字を超えると無効" do
    user = build(:user, email: "a" * 244 + "@example.com")
    expect(user).not_to be_valid
  end

  it "パスワードが空だと無効" do
    user = build(:user, password: "", password_confirmation: "")
    expect(user).not_to be_valid
  end

  it "パスワードが6文字未満だと無効" do
    user = build(:user, password: "123", password_confirmation: "123")
    expect(user).not_to be_valid
  end

  it "プロフィール画像が未添付でも保存できる" do
    user = build(:user)
    user.profile_image.purge # プロフィール画像を削除
    expect(user).to be_valid
  end
end
