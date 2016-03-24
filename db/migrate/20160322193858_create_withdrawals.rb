class CreateWithdrawals < ActiveRecord::Migration
  def change
    create_table :withdrawals do |t|
      t.integer :user_id
      t.float :amount
      t.boolean :completed

      t.timestamps null: false
    end
  end
end
