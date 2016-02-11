class AddPermissionsToUser < ActiveRecord::Migration
  def change
    add_column :users, :permissions, :int
  end
end
