class AddGameToContests < ActiveRecord::Migration
  def change
    add_column :contests, :game, :integer
  end
end
