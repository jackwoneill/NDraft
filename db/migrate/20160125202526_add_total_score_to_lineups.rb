class AddTotalScoreToLineups < ActiveRecord::Migration
  def change
    add_column :lineups, :total_score, :float
  end
end
