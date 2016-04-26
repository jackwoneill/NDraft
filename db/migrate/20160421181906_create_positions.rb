class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :game_id
      t.string :name
      t.string :abbr
      t.integer :pos_num
      t.integer :num_allowed

      t.timestamps null: false
    end
  end
end
