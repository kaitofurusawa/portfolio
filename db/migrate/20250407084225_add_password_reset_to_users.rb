class AddPasswordResetToUsers < ActiveRecord::Migration[8.0]
  def change
    begin
      add_column :users, :reset_password_token, :string
    rescue
      puts "reset_password_token already exists, skipping"
    end

    begin
      add_column :users, :reset_password_sent_at, :datetime
    rescue
      puts "reset_password_sent_at already exists, skipping"
    end
  end
end
