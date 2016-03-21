class CreateLineups < ActiveRecord::Migration
  def change
    create_table :lineups do |t|
      t.integer :contest_id
      t.integer :user_id
      t.integer :total_score
      t.integer :player_1
      t.integer :player_2
      t.integer :player_3
      t.integer :player_4
      t.integer :player_5
      t.integer :player_6
      t.integer :player_7
      t.integer :player_8

      t.timestamps null: false
    end
  end
end
