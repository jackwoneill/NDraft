class CreateStreamLinks < ActiveRecord::Migration
  def change
    create_table :stream_links do |t|
      t.integer :slate_id
      t.string :url

      t.timestamps null: false
    end
  end
end
