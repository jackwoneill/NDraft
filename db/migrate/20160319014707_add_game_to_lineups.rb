class AddGameToLineups < ActiveRecord::Migration
  def change
    add_column :lineups, :game, :integer
  end
end
