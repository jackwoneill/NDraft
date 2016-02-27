class AddCompletedToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :completed, :boolean
  end
end
