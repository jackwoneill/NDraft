class Addindexes < ActiveRecord::Migration
  def change
    add_index :lineups, :user_id
    add_index :lineups, :contest_id
  end
end
