class AddColumnToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :tweet_status_url, :string
  end
end
