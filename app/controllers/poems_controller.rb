require 'twitter_api'
require 'poem_module'

class PoemsController < ApplicationController
include TwitterApi
include PoemConstructor  

	def index
		
	end

	def create
		@poem = construct_poem(handle_check)
		redirect_to poem_path(@poem.id)
	end 
	
	def new

	end

	def show 
		# poems = Poem.find(params[:id]) 
		# @poems = []
		# @urls = []
		# poems.poem_tweets.each do |pt|
		# 	tweet = Tweet.find(pt.tweet_id)
	
		# 	@urls[pt.line_num - 1] = tweet.tweet_status_url
		# 	@poems[pt.line_num - 1] = tweet.text
		# end

	end

	private

	def poem_params
		params.require(:poem)
	end
end
