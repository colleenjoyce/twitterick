class AddIndexToTweets < ActiveRecord::Migration
  def change
  	add_index :tweets, :tweet_status_num, :unique => :true
  	add_index :tweets, :last_word
  end
end
