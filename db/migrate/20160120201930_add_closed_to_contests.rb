class AddClosedToContests < ActiveRecord::Migration
  def change
    add_column :contests, :closed, :boolean
  end
end
