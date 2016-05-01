class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :teams, :abbrev, :abbr
  end
end
