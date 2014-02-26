class CreateTwitterHandles < ActiveRecord::Migration
  def change
    create_table :twitter_handles do |t|
      t.string :handle

      t.timestamps
    end
  end
end
