class BoardsController < ApplicationController
  def index
    @boards = Board.page(params[:page]).per(20) # 1ページに20件表示
  end
end
