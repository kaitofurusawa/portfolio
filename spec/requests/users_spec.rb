require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "一覧ページが表示される" do
      get users_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("ユーザー一覧")
    end
  end

  describe "GET /users/:id" do
    it "詳細ページが表示される" do
      user = create(:user)
      get user_path(user)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(user.name)
    end
  end

  describe "POST /users" do
    it "新しいユーザーを作成できる" do
      user_params = attributes_for(:user)
      expect {
        post users_path, params: { user: user_params }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(User.last)
    end

    it "無効なパラメータの場合はエラーが表示される" do
      user_params = attributes_for(:user, name: nil)
      post users_path, params: { user: user_params }
      expect(response.body).to include("エラーが発生しました")
    end
  end

  describe "DELETE /users/:id" do
    it "ユーザーを削除できる" do
      user = create(:user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)

      expect(response).to redirect_to(users_path)
    end
  end
end
