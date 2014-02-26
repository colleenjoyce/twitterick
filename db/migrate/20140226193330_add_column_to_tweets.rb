class AddColumnToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :twitter_status_url, :string
  end
end
