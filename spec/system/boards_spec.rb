require 'rails_helper'

RSpec.describe "掲示板（何切る投稿）", type: :system, js: true do
  let!(:user) { create(:user) }

  before do
    driven_by :remote_chrome
    login_as(user)   # マクロでログイン（support/login_macros.rb推奨）
  end

  it "新規投稿ができる" do
    visit new_board_path
    fill_in "タイトル", with: "テスト投稿タイトル"
    fill_in "本文", with: "テスト投稿内容"
    click_button "投稿"
    expect(page).to have_content "投稿が完了しました"
    expect(page).to have_content "テスト投稿タイトル"
    expect(page).to have_content "テスト投稿内容"
  end

  it "タイトル未入力の場合エラーになる" do
    visit new_board_path
    fill_in "本文", with: "本文だけ"
    click_button "投稿"
    expect(page).to have_content "投稿に失敗しました"
    expect(page).to have_content "タイトルを入力してください"
  end

  it "投稿の編集ができる" do
    board = create(:board, user: user)
    login_as(user)
    visit edit_board_path(board)
    expect(page).to have_current_path(edit_board_path(board))
    fill_in "タイトル", with: "編集後タイトル"
    fill_in "本文", with: "編集後内容"
    click_button "更新"
    expect(page).to have_content "編集後タイトル"
    expect(page).to have_content "編集後内容"
  end

  it "投稿の削除ができる" do
    board = create(:board, user: user)
    login_as(user)
    visit edit_board_path(board)
    expect(page).to have_button("削除")
    find('button.delete-btn').click
    # 削除後の画面/メッセージ検証
    expect(page).to have_content "掲示板を削除しました"
  end

  it "画像付きで新規投稿ができる" do
    visit new_board_path
    fill_in "タイトル", with: "画像テスト"
    fill_in "本文", with: "画像投稿のテストです"
    attach_file "何切る画像", Rails.root.join("spec/fixtures/sample.jpg")
    click_button "投稿"
    expect(page).to have_content "投稿が完了しました"
    # 画像が表示されてることの確認（alt属性や画像URLなどで検証）
    expect(page).to have_selector("img")
  end
end
