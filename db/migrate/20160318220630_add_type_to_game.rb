class AddTypeToGame < ActiveRecord::Migration
  def change
    add_column :games, :type, :integer
  end
end
