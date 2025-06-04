class VotesController < ApplicationController
  before_action :require_login # ログイン必須

  def create
    poll_option = PollOption.find(params[:poll_option_id])
    poll = poll_option.poll

    # 二重投票防止
    if Vote.exists?(user: current_user, poll_option: poll.poll_options)
      redirect_to board_path(poll.board), alert: "すでに投票済みです"
      return
    end

    vote = Vote.new(user: current_user, poll_option: poll_option)

    if vote.save
      respond_to do |format|
        format.html { redirect_to board_path(poll.board), notice: "投票が完了しました" }
        format.turbo_stream # Turbo対応するならこのまま
      end
    else
      redirect_to board_path(poll.board), alert: "投票に失敗しました"
    end
  end
end
