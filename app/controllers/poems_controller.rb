require 'twitter_api'

class PoemsController < ApplicationController
include TwitterApi 

	def index
		
	end

	def create
		@handles = Hash.new
		params[:handles].each do |handle|
			begin 
				@handles[handle] = get_all_tweets(handle)
			rescue Exception => e 
				puts e
			end
		end

		# @handles.each do |handle|
		# 	handle.each do |tweet|
		# 	Tweet.create(
		# 		text: tweet.text, 
		# 		twitter_handle_id: tweet.user.screen_name,
		# 		tweet_status_url: "https://twitter.com" + tweet.url.path, 
		# 		tweet_status_num: tweet.id,
		# 		last_word: tweet.text.gsub(/[^\s\or\w]/,"").split(" ").last
		# 	)
		# 	end
		# end
		# redirect_to poem_path
		@handles 
	end 
	
	def new

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
