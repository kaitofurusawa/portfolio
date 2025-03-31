require 'rails_helper'

RSpec.describe "コメント機能", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:board) { create(:board, user: user) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  it "コメントを投稿できる" do
    visit board_path(board)

    fill_in "コメントを入力", with: "これはテストコメントです"
    click_button "コメント"

    expect(page).to have_content "これはテストコメントです"
    expect(page).to have_content "コメントを投稿しました"
  end

  it "空のコメントは投稿できない" do
    visit board_path(board)

    fill_in "コメントを入力", with: ""
    click_button "コメント"

    expect(page).to have_content "コメントを入力してください"
  end

  it "自分のコメントを編集できる" do
    comment = create(:comment, user: user, board: board, content: "編集前")

    visit board_path(board)

    within("#comment_#{comment.id}") do
      click_link "編集"
    end

    within("#edit_comment_#{comment.id}") do
      fill_in "コメントを入力", with: "編集後"
      click_button "更新"
    end

    expect(page).to have_content "編集後"
    expect(page).not_to have_content "編集前"
    expect(page).to have_content "コメントを更新しました"
  end

  it "自分のコメントを削除できる" do
    comment = create(:comment, user: user, board: board, content: "削除対象")

    visit board_path(board)

    within("#comment_#{comment.id}") do
      accept_confirm do
        click_link "削除"
      end
    end

    expect(page).not_to have_content "削除対象"
    expect(page).to have_content "コメントを削除しました"
  end

  it "他人のコメントは編集・削除できない" do
    comment = create(:comment, user: other_user, board: board, content: "他人のコメント")

    visit board_path(board)

    within("#comment_#{comment.id}") do
      expect(page).not_to have_link "編集"
      expect(page).not_to have_link "削除"
    end
  end
end