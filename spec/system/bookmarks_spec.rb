require 'rails_helper'

RSpec.describe "ブックマーク機能", type: :system, js: true do
  let!(:user)  { create(:user) }
  let!(:board) { create(:board) }

  before do
    driven_by :remote_chrome
    login_as(user)
    visit board_path(board)
  end

  it "ブックマーク・ブックマーク解除が非同期でできる" do
    find('button.bookmark-btn').click
    expect(page).to have_selector('img[alt="' + I18n.t('bookmarks.filled_alt') + '"]')
    accept_confirm(I18n.t('bookmarks.confirm_unbookmark')) do
      find('button.bookmark-btn').click
    end
    expect(page).to have_selector('img[alt="' + I18n.t('bookmarks.outline_alt') + '"]')
  end

  it "未ログイン時はブックマークボタンが表示されない" do
    visit login_path
    within("form#login_form") do
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    visit user_path(user)
    click_button "ログアウト"
    expect(page).to have_content "ログアウトしました"

    visit board_path(board)
    expect(page).not_to have_selector('button.bookmark-btn')
  end

  it "マイページのブックマーク一覧に追加・削除が反映される" do
    find('button.bookmark-btn').click

    visit user_path(user)
    expect(page).to have_link(I18n.t('users.show.all_bookmarks_link'))
    click_link I18n.t('users.show.all_bookmarks_link')
    expect(page).to have_content(board.title)

    visit board_path(board)
    accept_confirm(I18n.t('bookmarks.confirm_unbookmark')) do
      find('button.bookmark-btn').click
    end

    visit user_path(user)
    expect(page).not_to have_link(I18n.t('users.show.all_bookmarks_link'))
    expect(page).to have_content(I18n.t('users.show.no_bookmarks'))
  end
end
