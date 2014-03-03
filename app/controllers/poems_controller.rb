require 'twitter_api'
require 'poem_module'
require 'rhyme_module'

class PoemsController < ApplicationController
	include TwitterApi
	include PoemConstructor

	def index
		
	end

	def create
		twitter_handle = handle_check(params[:handle])
		if(twitter_handle)
			poem = construct_poem(twitter_handle)
			if (poem)
				@poem = poem.poem_tweets.order(:line_num)
				redirect_to poem_path(poem)
			end
		end
		#redirect to error
	end 
	
	def new

	end

	def show 
		@poem = Poem.find(params[:id])
		@tweets = @poem.poem_tweets.order(:line_num)
		@liked = Like.where(poem: @poem, user: current_user).count > 0
	end

	def like 
		Poem.find(params[:poem_id]).users << current_user
		redirect_to poem_path(params[:poem_id])
	end

	def dislike 
	end

	private

	def poem_params
		params.require(:poem)
	end

end
