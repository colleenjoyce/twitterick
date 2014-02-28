class PoemTweet < ActiveRecord::Base
	belongs_to :tweet
	belongs_to :poem
end
