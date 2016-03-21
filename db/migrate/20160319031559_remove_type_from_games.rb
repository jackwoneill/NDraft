class RemoveTypeFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :type, :integer
  end
end
