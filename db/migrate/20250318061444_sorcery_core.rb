class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      # t.string :email  ←これを消す（既にあるから）
      # t.string :crypted_password
      t.string :salt
      # t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
