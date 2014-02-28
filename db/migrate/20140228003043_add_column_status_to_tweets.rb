class AddColumnStatusToTweets < ActiveRecord::Migration
  def change
  	    add_column :tweets, :tweet_status_num, :string
  end
end
