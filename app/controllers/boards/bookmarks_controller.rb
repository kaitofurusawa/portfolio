# app/controllers/boards/bookmarks_controller.rb
class Boards::BookmarksController < ApplicationController
  before_action :require_login # sorceryのメソッド
  before_action :set_board

  def create
    @board.bookmarks.find_or_create_by(user: current_user)
    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @board.bookmarks.where(user: current_user).destroy_all
    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end
end
