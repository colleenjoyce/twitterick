require 'string'

class TweetValidation < ActiveModel::Validator
	def validate(tweet)
		if tweet.text.include?("@")
			tweet.errors[:base] << "This tweet refers to another user"
		end
		
		if tweet.text.include?("#")
			tweet.errors[:base] << "This tweet includes a hashtag"
		end
		
		if tweet.text.include?("http://")
			tweet.errors[:base] << "This tweet includes a url"
		end

		if tweet.text.syllable_count < 4 
			tweet.errors[:base] << "This tweet has less than four syllables"	
		end		
	end

end 

class Tweet < ActiveRecord::Base
	belongs_to :twitter_handle
	belongs_to :poem_tweet 
	has_many :poems, through: :poem_tweets

	validates :tweet_status_num, :twitter_handle_id, :tweet_status_url, presence: true
	validates :tweet_status_num, uniqueness: true
	validates_with TweetValidation
	after_create :set_syllables

	private

	def set_syllables
		self.num_syllables = self.text.syllable_count
		self.save
	end
end
