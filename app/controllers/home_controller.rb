class HomeController < ApplicationController
  def index
    @boards = Board.limit(20) # 最新の20件を表示
  end
end
