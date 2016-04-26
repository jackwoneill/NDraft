class CreateLineups < ActiveRecord::Migration
  def change
    create_table :lineups do |t|
      t.integer :contest_id
      t.integer :user_id
      t.float :total_score
      t.integer :gametype

      t.timestamps null: false
    end
  end
end
