require 'string.rb'

class Tweet < ActiveRecord::Base
include String 

	belongs_to :twitter_handle
	belongs_to :poem_tweet 
	has_many :poems, through: :poem_tweets

	after_create :set_syllables

	private
	def set_syllables
		self.num_syllable = self.text.syllable_count
		self.save
	end

end
