class AddTotalWinningsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_winnings, :float
  end
end
