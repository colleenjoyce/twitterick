class AddColumnToTwitterHandles < ActiveRecord::Migration
  def change
  	 add_column :twitter_handles, :last_searched, :datetime
  	 add_index :twitter_handles, :last_searched
  end
end
