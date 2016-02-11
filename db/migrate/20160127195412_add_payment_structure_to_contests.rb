class AddPaymentStructureToContests < ActiveRecord::Migration
  def change
    add_column :contests, :payment_structure, :integer
  end
end
