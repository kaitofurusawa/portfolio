require 'rails_helper'

RSpec.describe "Boards", type: :request do
  describe "GET /boards" do
    it "一覧ページが表示される" do
      get boards_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("掲示板一覧")
    end
  end

  describe "GET /boards/:id/edit" do
    it "編集ページが表示される" do
      user = create(:user)
      board = create(:board, user: user)
      login(user)

      get edit_board_path(board)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("編集ページ")
    end
  end

  describe "POST /boards" do
    it "新しい掲示板を作成できる" do
      user = create(:user)
      login(user)

      board_params = attributes_for(:board)
      expect {
        post boards_path, params: { board: board_params }
      }.to change(Board, :count).by(1)

      expect(response).to redirect_to(Board.last)
    end

    it "無効なパラメータの場合はエラーが表示される" do
      user = create(:user)
      login(user)

      board_params = attributes_for(:board, title: nil)
      post boards_path, params: { board: board_params }
      expect(response.body).to include("エラーが発生しました")
    end
  end

  describe "DELETE /boards/:id" do
    it "掲示板を削除できる" do
      user = create(:user)
      board = create(:board, user: user)
      login(user)

      expect {
        delete board_path(board)
      }.to change(Board, :count).by(-1)

      expect(response).to redirect_to(boards_path)
    end
  end
end
