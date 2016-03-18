class RemoveTokenFromDeposits < ActiveRecord::Migration
  def change
    remove_column :deposits, :token, :string
  end
end
