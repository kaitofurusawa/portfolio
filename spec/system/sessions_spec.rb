require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }

  it "ログインできてログアウトできること" do
    visit login_path

    fill_in "メールアドレス", with: "test@example.com"
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).to have_content "ログインしました"
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました"
  end

  it "ログインに失敗する" do
    visit login_path

    fill_in "メールアドレス", with: "wrong@example.com"
    fill_in "パスワード", with: "wrongpassword"
    click_button "ログイン"

    expect(page).to have_content "ログインに失敗しました"
  end
end
