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
      expect(page).to have_content("テストコメント")
      expect(page).to have_content(user.name)
    end

    it "コメントを削除すると非同期で消える" do
      fill_in "コメントを入力", with: "削除テストコメント"
      click_button I18n.t('buttons.comment')
      expect(page).to have_content("削除テストコメント")

      within('.comment-container', text: "削除テストコメント") do
        accept_confirm(I18n.t('comments.delete_confirm')) do
          click_link I18n.t('buttons.delete')
        end
      end

      expect(page).not_to have_content("削除テストコメント")
    end

    it "コメント内容が空ならバリデーションエラーになる" do
      click_button I18n.t('buttons.comment')
      expect(page).to have_content(I18n.t('activerecord.errors.models.comment.attributes.content.blank'))
    end
  end

  context "未ログイン時" do
    it "コメントフォームが表示されない" do
      visit board_path(board)
      expect(page).not_to have_selector('form.comment-form')
    end
  end
end
