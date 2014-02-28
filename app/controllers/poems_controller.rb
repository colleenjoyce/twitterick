class PoemsController < ApplicationController
	def index
		
	end

	def create
			
	end

	def show 
		poems = Poem.find(params[:id]) 
		@poems = []
		@urls = []
		poems.poem_tweets.each do |pt|
			tweet = Tweet.find(pt.tweet_id)
	
			@urls[pt.line_num - 1] = tweet.tweet_status_url
			@poems[pt.line_num - 1] = tweet.text
		end

	end

	private
	def poem_params
		params.require(:poem)
	end
end
