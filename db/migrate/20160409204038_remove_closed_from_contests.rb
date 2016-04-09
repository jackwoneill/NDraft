class RemoveClosedFromContests < ActiveRecord::Migration
  def change
    remove_column :contests, :closed, :boolean
  end
end
