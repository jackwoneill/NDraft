class AddGametypeIdToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :gametype_id, :integer
  end
end
