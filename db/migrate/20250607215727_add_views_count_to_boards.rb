class AddViewsCountToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :views_count, :integer, null: false, default: 0
  end
end
