class CreatePolls < ActiveRecord::Migration[8.0]
  def change
    create_table :polls do |t|
      t.string :question
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
