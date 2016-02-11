class RemoveStartTimeFromContests < ActiveRecord::Migration
  def change
    remove_column :contests, :start_time, :string
  end
end
