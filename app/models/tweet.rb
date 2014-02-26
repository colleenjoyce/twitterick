class Tweet < ActiveRecord::Base
	belongs_to :twitter_handle
	belongs_to :poem_tweet 
	belongs_to :poem through: :poem_tweets
end
