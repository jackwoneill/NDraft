class AddNumFlexToGametypes < ActiveRecord::Migration
  def change
    add_column :gametypes, :num_flex, :integer
  end
end
