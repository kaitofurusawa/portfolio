require 'rails_helper'

RSpec.describe "掲示板一覧 検索・ソート機能", type: :system, js: true do
  let!(:user1) { create(:user, name: "田中 太郎") }
  let!(:user2) { create(:user, name: "山田 花子") }

  let!(:board1) { create(:board, title: "初投稿", content: "これはテスト本文", user: user1, views_count: 100, created_at: 2.days.ago) }
  let!(:board2) { create(:board, title: "検索対象記事", content: "内容にRuby", user: user2, views_count: 200, created_at: 1.day.ago) }
  let!(:board3) { create(:board, title: "複数ワード テスト", content: "Mahjong Ruby", user: user1, views_count: 50, created_at: 3.days.ago) }

  before do
    driven_by :remote_chrome
    visit boards_path
  end

  describe "検索機能" do
    it "タイトルで検索できる" do
      fill_in "タイトル・本文・ユーザー名で検索", with: "初投稿"
      click_button "検索"
      expect(page).to have_content("初投稿")
      expect(page).not_to have_content("検索対象記事")
    end

    it "本文で検索できる" do
      fill_in "タイトル・本文・ユーザー名で検索", with: "Ruby"
      click_button "検索"
      expect(page).to have_content("検索対象記事")
      expect(page).to have_content("複数ワード テスト")
      expect(page).not_to have_content("初投稿")
    end

    it "ユーザー名で検索できる" do
      fill_in "タイトル・本文・ユーザー名で検索", with: "田中"
      click_button "検索"
      expect(page).to have_content("初投稿")
      expect(page).to have_content("複数ワード テスト")
      expect(page).not_to have_content("検索対象記事")
    end

    it "スペース区切りで複数ワード検索できる" do
      fill_in "タイトル・本文・ユーザー名で検索", with: "Mahjong Ruby"
      click_button "検索"
      expect(page).to have_content("複数ワード テスト")
      expect(page).not_to have_content("初投稿")
      expect(page).not_to have_content("検索対象記事")
    end

    it "検索にヒットしなければ0件になる" do
      fill_in "タイトル・本文・ユーザー名で検索", with: "絶対に無いキーワード"
      click_button "検索"
      expect(page).to have_content(I18n.t('boards.index.no_results'))
    end
  end

  describe "ソート機能" do
    it "デフォルトで新着順になっている" do
      titles = all(".board-card h3").map(&:text)
      expect(titles).to eq([ "検索対象記事", "初投稿", "複数ワード テスト" ])
    end

    it "閲覧数順でソートできる" do
      click_link "閲覧数順"
      expect(page).to have_selector(".board-card h3", text: "検索対象記事") # ←ここでリロード完了をwait
      titles = all(".board-card h3").map(&:text)
      expect(titles).to eq([ "検索対象記事", "初投稿", "複数ワード テスト" ])
    end

    it "新着順にソートし直せる" do
      click_link "閲覧数順"
      click_link "新着順"
      titles = all(".board-card h3").map(&:text)
      expect(titles).to eq([ "検索対象記事", "初投稿", "複数ワード テスト" ])
    end
  end

  describe "未ログインでも利用できる" do
    it "ログアウト状態でも検索できる" do
      visit logout_path if page.has_button?("ログアウト")
      visit boards_path
      fill_in "タイトル・本文・ユーザー名で検索", with: "初投稿"
      click_button "検索"
      expect(page).to have_content("初投稿")
    end

    it "ログアウト状態でもソートできる" do
      visit logout_path if page.has_button?("ログアウト")
      visit boards_path
      click_link "閲覧数順"
      expect(all(".board-card h3").first.text).to eq("検索対象記事")
    end
  end
end
