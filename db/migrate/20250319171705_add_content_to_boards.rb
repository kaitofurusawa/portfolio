class AddContentToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :content, :text
  end
end
