class PoemTweet < ActiveRecord::Base
	has_many :tweets
	has_many :poems
end
