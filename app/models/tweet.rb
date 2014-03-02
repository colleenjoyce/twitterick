require 'syllable_module'
require 'rhyme_module'

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

		if tweet.text.include?("https://")
			tweet.errors[:base] << "This tweet includes a url"
		end

		if tweet.text.syllable_count < 4 
			tweet.errors[:base] << "This tweet has less than four syllables"	
		end	

		if tweet.text.syllable_count > 10 
			tweet.errors[:base] << "This tweet has more than ten syllables"	
		end			
	end

end 

class Tweet < ActiveRecord::Base
	belongs_to :twitter_handle
	has_many :poem_tweets 
	has_many :poems, through: :poem_tweets

	validates :tweet_status_num, :twitter_handle_id, :tweet_status_url, presence: true
	validates :tweet_status_num, uniqueness: true
	validates_with TweetValidation
	after_create :set_num_syllables
	after_create :set_num_rhymes

	private

	def set_num_syllables
		self.num_syllables = self.text.syllable_count
		self.save
	end

	def set_num_rhymes
		self.num_rhymes = RhymingWords.get_num_rhymes(self.last_word)
		self.save
	end
end
