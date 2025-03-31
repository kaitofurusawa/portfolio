require 'rails_helper'

RSpec.describe "UserRegistrations", type: :system do
  it "ユーザー登録できること" do
    visit new_user_path

    fill_in "名前", with: "テスト太郎"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認用）", with: "password"

    click_button "登録"

    expect(page).to have_content "ユーザー登録が完了しました"
    expect(current_path).to eq root_path
  end

  it "無効なメールアドレスではユーザー登録できないこと" do
    visit new_user_path

    fill_in "名前", with: "テスト太郎"
    fill_in "メールアドレス", with: "invalid_email"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認用）", with: "password"

    click_button "登録"

    expect(page).to have_content "メールアドレスは不正な値です"
  end

  it "パスワードが一致しない場合はユーザー登録できないこと" do
    visit new_user_path

    fill_in "名前", with: "テスト太郎"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認用）", with: "different_password"

    click_button "登録"

    expect(page).to have_content "パスワード確認とパスワードの入力が一致しません"
  end

  it "既に登録されているメールアドレスではユーザー登録できないこと" do
    create(:user, email: "test@example.com")

    visit new_user_path

    fill_in "名前", with: "テスト太郎"
    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認用）", with: "password"

    click_button "登録"

    expect(page).to have_content "メールアドレスはすでに存在します"
  end
end