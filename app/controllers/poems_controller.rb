require 'twitter_api'
require 'poem_module'
require 'rhyme_module'

class PoemsController < ApplicationController
	include TwitterApi
	include PoemConstructor

	def index
		@poem = Poem.all.sample
		@tweets = @poem.poem_tweets.order(:line_num)
		if (current_user)
			@liked = Like.where(poem: @poem, user: current_user).first
		end
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
		if (current_user)
			@liked = Like.where(poem: @poem, user: current_user).first
		end
	end

	def like 
		if params[:like] == "true"
			Poem.find(params[:poem_id]).users << current_user
		else
			like = Like.where(user_id: current_user.id, poem_id: params[:poem_id]).first
			like.destroy 
		end
		redirect_to poem_path(params[:poem_id])
	end

	def dislike 

	end

	private

	def poem_params
		params.require(:poem)
	end

end
