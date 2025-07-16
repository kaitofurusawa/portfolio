module BookmarksHelper
  def render_bookmark_button(board)
    if defined?(logged_in?) && logged_in?
      render partial: "boards/bookmark", locals: { board: board, current_user: current_user }
    end
    # 未ログイン時は何も返さない（=非表示）
  end
end
