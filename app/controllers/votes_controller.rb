class VotesController < ApplicationController
  before_action :require_login # ログイン必須

  def create
    vote = current_user.votes.build(poll_option_id: params[:vote][:poll_option_id])
    if vote.save
      respond_to do |format|
        format.turbo_stream do
          @poll = vote.poll_option.poll
          render turbo_stream: turbo_stream.replace(
            "poll_#{@poll.id}",
            partial: "boards/poll_frame",
            locals: { board: @poll.board, poll: @poll, current_user: current_user }
          )
        end
        format.html { redirect_to board_path(@poll.board), notice: t("votes.create.success") }
      end
    else
      redirect_back fallback_location: root_path, alert: t("votes.create.failure")
    end
  end
end
