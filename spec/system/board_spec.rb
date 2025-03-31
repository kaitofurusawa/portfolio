require 'rails_helper'

RSpec.describe "Boards", type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  it "掲示板を投稿できる" do
    visit new_board_path

    fill_in "タイトル", with: "テスト掲示板"
    fill_in "本文", with: "これはテストです"

    attach_file "画像", Rails.root.join("spec/fixtures/sample.jpg")
    click_button "投稿"

    expect(page).to have_content "掲示板を投稿しました"
    expect(page).to have_content "テスト掲示板"
    expect(page).to have_selector("img")
  end

  it "掲示板の投稿に失敗する" do
    visit new_board_path

    fill_in "タイトル", with: ""
    fill_in "本文", with: ""

    click_button "投稿"

    expect(page).to have_content "タイトルを入力してください"
    expect(page).to have_content "本文を入力してください"
  end
end
