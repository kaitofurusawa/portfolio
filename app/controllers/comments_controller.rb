class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]

  def create
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board, alert: "コメント投稿失敗" }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    render partial: "comments/edit_form", locals: { comment: @comment }
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @comment.board }
      end
    else
      # 更新失敗時の処理を追加するならここ
      respond_to do |format|
        format.html { redirect_to @comment.board, alert: "更新に失敗しました" }
      end
    end
  end

  def destroy
    @board = @comment.board
    if @comment.user == current_user
      comment_id = @comment.id
      @comment.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("comment_#{comment_id}") }
        format.html { redirect_to @board }
      end
    else
      redirect_to @board, alert: "削除権限がありません"
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
