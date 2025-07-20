class VotesController < ApplicationController
  before_action :require_login # ログイン必須

  def create
    poll_option_id = params.dig(:vote, :poll_option_id)
    unless poll_option_id.present?
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "選択肢を選択してください"
          @poll = Poll.find(params[:poll_id])
          render turbo_stream: turbo_stream.replace(
            "poll_#{@poll.id}",
            partial: "boards/poll_frame",
            locals: { board: @poll.board, poll: @poll, current_user: current_user }
          )
        end
        format.html { redirect_back fallback_location: root_path, alert: "選択肢を選択してください" }
      end
      return
    end

    vote = current_user.votes.build(poll_option_id: poll_option_id)
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
      end
    else
      redirect_back fallback_location: root_path, alert: "投票に失敗しました"
    end
  end
end
