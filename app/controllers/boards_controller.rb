class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update]

  def new
    @board = Board.new
  end

  def index
    @boards = Board.order(created_at: :desc).page(params[:page]).per(20) # 1ページに20件表示
  end

  def show
    @board = Board.find(params[:id])
  end

  def edit
    @board = Board.find(params[:id])
  end

  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to @board, notice: t('boards.create.success')
    else
      flash.now[:alert] = t('boards.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @board.update(board_params)
      redirect_to @board, notice: t('boards.update.success')
    else
      flash.now[:alert] = t('boards.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board = Board.find(params[:id])
    if @board.user == current_user
      @board.destroy
      redirect_to root_path, notice: t('boards.delete.success')
    else
      redirect_to board_path(@board), alert: t('boards.delete.failure')
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
