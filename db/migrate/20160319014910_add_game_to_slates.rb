class AddGameToSlates < ActiveRecord::Migration
  def change
    add_column :slates, :game, :integer
  end
end
