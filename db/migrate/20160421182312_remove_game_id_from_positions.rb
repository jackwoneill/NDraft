class RemoveGameIdFromPositions < ActiveRecord::Migration
  def change
    remove_column :positions, :game_id, :integer
  end
end
