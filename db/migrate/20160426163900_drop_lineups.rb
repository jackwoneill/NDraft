class DropLineups < ActiveRecord::Migration
  def change
    drop_table :lineups
  end
end
