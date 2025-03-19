class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update]

  def index
    @boards = Board.order(created_at: :desc).page(params[:page]).per(20) # 1ページに20件表示
  end

  def show
    @board = Board.find(params[:id])
  end

  def edit
    @board = Board.find(params[:id])
  end

  def update
    if @board.update(board_params)
      redirect_to @board, notice: t('boards.update.success')
    else
      flash.now[:alert] = t('boards.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :content, :image) # `image` を追加
  end
end
