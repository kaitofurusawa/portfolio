require 'rails_helper'

RSpec.describe "アンケート投票", type: :system, js: true do
  let!(:user)  { create(:user) }
  let!(:board) { create(:board) }
  let!(:poll)  { create(:poll, board: board) }

  before do
    board.reload
    poll.reload
    driven_by :remote_chrome
  end

  let!(:option1) { poll.poll_options.first }
  let!(:option2) { poll.poll_options.second }

  it "ユーザーが投票できる" do
    login_as(user)
    visit board_path(board)
    expect(page).to have_content "質問: テスト"
    expect(page).to have_content "A"
    expect(page).to have_content "B"

    find('.poll-option-box', text: 'A').click

    click_button "投票する"

    expect(page).to have_content "A"
    expect(page).to have_content "100%"
    expect(page).to have_content "（1票）"
    expect(page).to have_content "あなたの投票"
    expect(page).to have_content "合計1票"
    expect(page).not_to have_button("投票する")
  end

  it "未ログインユーザーは投票できず、フォームが表示されない" do
    logout if page.has_link?('ログアウト')
    visit board_path(board)
    expect(page).not_to have_button "投票する"
    expect(page).not_to have_selector("input[type='radio'][value='#{option1.id}']", visible: :all)
    expect(page).to have_content("ログイン")
  end

  it "既に投票済みの場合、再投票できない" do
    create(:vote, user: user, poll_option: option1)
    login_as(user)
    visit board_path(board)
    save_page

    expect(page).not_to have_button "投票する"
    expect(page).to have_content('あなたの投票')
  end

  it "選択肢を選ばず投票するとエラーになる" do
    login_as(user)
    visit board_path(board)
    save_page

    expect(page).to have_button "投票する"
    click_button "投票する"
    expect(page).to have_content("選択肢を選択してください")
  end
end
