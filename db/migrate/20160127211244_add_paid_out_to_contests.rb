class AddPaidOutToContests < ActiveRecord::Migration
  def change
    add_column :contests, :paid_out, :boolean
  end
end
