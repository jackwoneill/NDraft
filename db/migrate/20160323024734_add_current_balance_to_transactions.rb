class AddCurrentBalanceToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :current_balance, :float
  end
end
