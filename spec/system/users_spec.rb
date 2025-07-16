require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system, js: true do
  before do
    driven_by :remote_chrome
  end

  it "新規ユーザー登録ができる（正常系）" do
    visit new_user_path

    fill_in "名前", with: "テスト太郎"
    fill_in "メールアドレス", with: "signup_test@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認）", with: "password"

    click_button "登録する"
    expect(page).to have_content "ユーザー登録が完了しました"
  end

  it "入力不足の場合はエラーになる（異常系）" do
    visit new_user_path

    # 名前だけ未入力で登録
    fill_in "メールアドレス", with: "signup_error@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認）", with: "password"

    click_button "登録する"
    expect(page).to have_content "登録に失敗しました"
    expect(page).to have_content "名前を入力してください"
  end

  it "パスワード不一致の場合はエラーになる（異常系）" do
    visit new_user_path

    fill_in "名前", with: "不一致太郎"
    fill_in "メールアドレス", with: "signup_error2@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認）", with: "different"

    click_button "登録する"
    expect(page).to have_content "登録に失敗しました"
    expect(page).to have_content "パスワードと確認用パスワードが一致しません"
  end

  it "既存のメールアドレスでは登録できない（異常系）" do
    # 事前に同じアドレスでユーザーを作成
    User.create!(name: "既存ユーザー", email: "signup_dup@example.com", password: "password", password_confirmation: "password")

    visit new_user_path
    fill_in "名前", with: "ダブり太郎"
    fill_in "メールアドレス", with: "signup_dup@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード（確認）", with: "password"

    click_button "登録する"
    expect(page).to have_content "登録に失敗しました"
    expect(page).to have_content "このメールアドレスは既に使用されています"
  end
end
