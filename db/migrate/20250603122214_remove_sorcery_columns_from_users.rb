class RemoveSorceryColumnsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :crypted_password, :string if column_exists?(:users, :crypted_password)
    remove_column :users, :salt, :string if column_exists?(:users, :salt)
    remove_column :users, :reset_password_token, :string if column_exists?(:users, :reset_password_token)
    remove_column :users, :reset_password_sent_at, :datetime if column_exists?(:users, :reset_password_sent_at)
  end
end
