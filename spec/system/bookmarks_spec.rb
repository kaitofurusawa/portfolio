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
    # ブックマーク追加
    find('button.bookmark-btn').click
    expect(page).to have_selector('img[alt="' + I18n.t('bookmarks.filled_alt') + '"]')

    # ブックマーク解除（confirmを自動でOKする！）
    accept_confirm(I18n.t('bookmarks.confirm_unbookmark')) do
      find('button.bookmark-btn').click
    end
    expect(page).to have_selector('img[alt="' + I18n.t('bookmarks.outline_alt') + '"]')
  end

  it "未ログイン時はブックマークボタンが表示されない" do
    # まずログイン
    visit login_path
    within("form#login_form") do
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end
  
    # そしてログアウト
    visit user_path(user)
    click_button "ログアウト"
    expect(page).to have_content "ログアウトしました" # 念のため
  
    # 未ログイン状態で掲示板詳細へ
    visit board_path(board)
    # ブックマークボタンが表示されていないことを確認
    expect(page).not_to have_selector('button.bookmark-btn')
  end

  it "マイページのブックマーク一覧に追加・削除が反映される" do
    # 1. ブックマーク追加
    find('button.bookmark-btn').click
  
    # 2. マイページへ
    visit user_path(user)
    # ブックマーク1件以上なのでリンクが出てるはず
    expect(page).to have_link(I18n.t('users.show.all_bookmarks_link'))
    click_link I18n.t('users.show.all_bookmarks_link')
    expect(page).to have_content(board.title)
  
    # 3. ブックマーク解除
    visit board_path(board)
    accept_confirm(I18n.t('bookmarks.confirm_unbookmark')) do
      find('button.bookmark-btn').click
    end
  
    # 4. 再度マイページに戻る
    visit user_path(user)
    # ブックマーク0件になったのでリンクが消えるはず
    expect(page).not_to have_link(I18n.t('users.show.all_bookmarks_link'))
    # ブックマーク0件用のテキストも確認
    expect(page).to have_content(I18n.t('users.show.no_bookmarks'))
  end
  
end