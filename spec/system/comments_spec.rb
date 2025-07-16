require 'rails_helper'

RSpec.describe "コメント機能", type: :system, js: true do
  let!(:user)  { create(:user) }
  let!(:board) { create(:board) }

  before do
    driven_by :remote_chrome
  end

  context "ログイン時" do
    before do
      login_as(user)
      visit board_path(board)
    end

    it "コメントを投稿すると非同期で反映される" do
      fill_in "コメントを入力", with: "テストコメント"
      click_button I18n.t('buttons.comment')
      # 投稿した内容が即時反映されているかをチェック
      expect(page).to have_content("テストコメント")
      # 投稿ユーザー名も表示
      expect(page).to have_content(user.name)
      # フラッシュに依存しない
    end

    it "コメントを削除すると非同期で消える" do
      fill_in "コメントを入力", with: "削除テストコメント"
      click_button I18n.t('buttons.comment')
      expect(page).to have_content("削除テストコメント")

      # コメントのブロック内で削除
      within('.comment-container', text: "削除テストコメント") do
        accept_confirm(I18n.t('comments.delete_confirm')) do
          click_link I18n.t('buttons.delete')
          # もしくは click_link '削除'
        end
      end

      # 削除後にコメントが消えていることを確認
      expect(page).not_to have_content("削除テストコメント")
    end

    it "コメント内容が空ならバリデーションエラーになる" do
      click_button I18n.t('buttons.comment')
      # バリデーションエラーが表示されることを確認
      expect(page).to have_content(I18n.t('activerecord.errors.models.comment.attributes.content.blank'))
    end
  end

  context "未ログイン時" do
    it "コメントフォームが表示されない" do
      visit board_path(board)
      # コメントフォーム要素が存在しないことを確認（idやclassで）
      expect(page).not_to have_selector('form.comment-form')
      # もしくは、ログイン中のみコメントできる旨の表示があるなら
      # expect(page).to have_content(I18n.t('comments.login_required'))
    end
  end
end
