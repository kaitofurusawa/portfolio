class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.string :title
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
