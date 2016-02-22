class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :amount
      t.integer :user_id
      t.string :description

      t.timestamps null: false
    end
  end
end
