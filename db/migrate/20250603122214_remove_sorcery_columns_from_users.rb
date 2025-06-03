class RemoveSorceryColumnsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :crypted_password, :string
    remove_column :users, :salt, :string
    remove_column :users, :reset_password_token, :string
    remove_column :users, :password_reset_sent_at, :datetime
  end
end
