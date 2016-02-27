class AddPaymentIdToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :payment_id, :string
  end
end
