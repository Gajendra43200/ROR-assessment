class AddTwoFactorAuthToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :otp_secret, :string
    add_column :users, :otp_required, :boolean
    add_column :users, :default, :string
    add_column :users, :false, :string
  end
end
