class CommentsController < ApplicationController
  before_action :set_comment, only: [ :update, :destroy ]

  def create
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board, notice: t("comments.create.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "comment_form",
            partial: "comments/form",
            locals: { board: @board, comment: @comment }
          )
        end
        format.html { redirect_to @board, alert: t("comments.create.failure") }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.turbo_stream
      format.html { render partial: "comments/edit_form", locals: { comment: @comment } }
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @comment.board, notice: t("comments.update.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "comment_#{@comment.id}",
            partial: "comments/edit_form",
            locals: { comment: @comment }
          )
        end
        format.html { redirect_to @comment.board, alert: t("comments.update.failure") }
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
        format.html { redirect_to @board, notice: t("comments.destroy.success") }
      end
    else
      redirect_to @board, alert: t("comments.destroy.failure")
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
