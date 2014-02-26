class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_handle_id, :integer
  end
end
