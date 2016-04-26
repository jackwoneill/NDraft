class CreateLineupPlayers < ActiveRecord::Migration
  def change
    create_table :lineup_players do |t|
      t.integer :lineup_id
      t.integer :player_id

      t.timestamps null: false
    end
  end
end
