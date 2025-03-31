require 'rails_helper'

RSpec.describe "Comments", type: :request do
  describe "POST /boards/:board_id/comments" do
    it "コメントを投稿できる" do
      user = create(:user)
      board = create(:board, user: user)
      login(user)

      expect {
        post board_comments_path(board), params: { comment: { content: "ナイス手ですね" } }
      }.to change(Comment, :count).by(1)

      expect(response).to redirect_to(board_path(board))
    end

    it "無効なコメントの場合はエラーが表示される" do
      user = create(:user)
      board = create(:board, user: user)
      login(user)

      post board_comments_path(board), params: { comment: { content: "" } }
      expect(response.body).to include("エラーが発生しました")
    end
  end

  describe "DELETE /boards/:board_id/comments/:id" do
    it "コメントを削除できる" do
      user = create(:user)
      board = create(:board, user: user)
      comment = create(:comment, board: board, user: user)
      login(user)

      expect {
        delete board_comment_path(board, comment)
      }.to change(Comment, :count).by(-1)

      expect(response).to redirect_to(board_path(board))
    end
  end
end
