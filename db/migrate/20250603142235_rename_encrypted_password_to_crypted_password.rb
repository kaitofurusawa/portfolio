class RenameEncryptedPasswordToCryptedPassword < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :encrypted_password, :crypted_password
  end
end

