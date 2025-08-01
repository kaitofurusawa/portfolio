class BoardsController < ApplicationController
  before_action :set_board, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user, only: [ :edit, :update, :destroy ]

  def new
    @board = Board.new
    @board.build_poll unless @board.poll
    2.times { @board.poll.poll_options.build }
  end

  def index
    sort = params[:sort] || "new" # デフォルトは新着順

    @boards = Board.joins(:user)

    if params[:q].present?
      keywords = params[:q].strip.split(/[[:space:]]+/)
      keywords.each_with_index do |word, i|
        @boards = @boards.where(
          "(boards.title LIKE :kw OR boards.content LIKE :kw OR users.name LIKE :kw)",
          kw: "%#{word}%"
        )
      end
    end

    # ソート
    @boards =
      case sort
      when "view"
        @boards.order(views_count: :desc)
      else
        @boards.order(created_at: :desc)
      end

    # ページネーション
    @boards = @boards.page(params[:page]).per(20)
  end

  def show
    @board = Board.find(params[:id])
    @comments = @board.comments.order(created_at: :asc)
    @board.increment!(:views_count)
  end

  def edit
    @board.build_poll unless @board.poll
    @board.poll.poll_options.build while @board.poll.poll_options.size < 2
  end

  def create
    if params[:board][:poll_attributes] &&
        params[:board][:poll_attributes][:question].blank? &&
        (
          params[:board][:poll_attributes][:poll_options_attributes].blank? ||
          params[:board][:poll_attributes][:poll_options_attributes].each_value.all? { |opt| opt[:content].blank? }
        )
      params[:board].delete(:poll_attributes)
    end

    @board = current_user.boards.build(board_params)
    if @board.save
      redirect_to @board, notice: t("boards.create.success")
    else
      flash.now[:alert] = t("boards.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def update
      if params[:board][:poll_attributes] &&
        params[:board][:poll_attributes][:question].blank? &&
          (
            params[:board][:poll_attributes][:poll_options_attributes].blank? ||
            params[:board][:poll_attributes][:poll_options_attributes].each_value.all? { |opt| opt[:content].blank? }
          )
        @board.poll&.destroy
        params[:board].delete(:poll_attributes)
      end

    if @board.update(board_params)
      redirect_to @board, notice: t("boards.update.success")
    else
      flash.now[:alert] = t("boards.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @board.destroy
      redirect_to root_path, notice: t("boards.delete.success")
    else
      redirect_to board_path(@board), alert: t("boards.delete.failure")
    end
  end

  def autocomplete
    keyword = params[:term]
    boards = Board.where("title LIKE ?", "%#{keyword}%").limit(10)
    render json: boards.pluck(:title)
  end

  private
  def set_board
    @board = Board.find(params[:id])
  end

  def authorize_user
    unless @board.user == current_user
      redirect_to(root_path, alert: t("boards.unauthorized"))
    end
  end

  def board_params
    params.require(:board).permit(
      :title, :content, :image,
      poll_attributes: [
        :question,
        poll_options_attributes: [ :content, :_destroy ]
      ]
    )
  end
end
