require 'twitter_api'

class PoemsController < ApplicationController
include TwitterApi 

	def index
		
	end

	def create
		@handles = Hash.new
		params[:handles].each do |handle|
			#if handle is not blank 
			if handle != "" 
				#strips @ sign from handle 
				handle = handle[1..handle.length]
				#if twitter handle is in db already
				if (th = TwitterHandle.find_by_handle(handle))                         #check for date
					tweets = get_all_tweets(handle)
					push_tweets(th.id, tweets)
				else #twitter handle is not in db
					begin # search, retrieve twitter for tweets by given handle  
						tweets = get_all_tweets(handle)
						# if handle is found on twitter, create handle in db 
						th = TwitterHandle.create(handle: handle)
						# for each tweet found, create Tweet in db 
						push_tweets(th.id, tweets)

						# if there's a problem in begin, rescue here 
					rescue
					end
				end
			end
			

		end

		# @handles.each do |handle|
		# 	handle.each do |tweet|
		# 	
		# 	end
		# end
		# redirect_to poem_path
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

	def push_tweets(twitter_handle_id, tweets)
		tweets.each do |tweet|
		Tweet.create(
			text: tweet.text, 
			twitter_handle_id: twitter_handle_id,
			tweet_status_url: "https://twitter.com" + tweet.url.path, 
			tweet_status_num: tweet.id,
			last_word: tweet.text.gsub(/[^\s\or\w]/,"").split(" ").last
		)
		end
	end


	def poem_params
		params.require(:poem)
	end
end
