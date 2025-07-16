require 'rails_helper'

RSpec.describe "ユーザーのログイン・ログアウト", type: :system, js: true do
  let!(:user) { create(:user, id: 1, email: "test@example.com", password: "password") }

  before do
    driven_by :remote_chrome
  end

  it "ログインできる" do
    visit login_path
    within("form#login_form") do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "password"
      click_button "ログイン"
    end

    expect(page).to have_content "ログインに成功しました"
    visit user_path(user) # ここでマイページに遷移
    expect(page).to have_button "ログアウト" # ←リンクじゃなくボタン！
    expect(page).to have_content user.name
  end

  it "ログアウトできる" do
    visit login_path
    within("form#login_form") do
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    visit user_path(user)

    expect(page).to have_selector("button.logout-btn") # ここでボタン確認
    click_button "ログアウト"

    expect(page).to have_content "ログアウトしました"
    expect(page).to have_button "ログイン"
  end

  it "存在しないユーザーだとエラーになる" do
    visit login_path
    within("form#login_form") do
      fill_in "メールアドレス", with: "notfound@example.com"
      fill_in "パスワード", with: "invalid"
      click_button "ログイン"
    end

    expect(page).to have_content "ログインに失敗しました"
  end

  it "パスワードが違う場合エラーになる" do
    visit login_path
    within("form#login_form") do
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "wrongpass"
      click_button "ログイン"
    end

    expect(page).to have_content "ログインに失敗しました"
  end
end
