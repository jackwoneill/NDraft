class AddAccountVerificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_verification, :integer
  end
end
