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
		if (poem = construct_poem(TwitterHandle.find(params[:id])))
			@poem = poem.poem_tweets.order(:line_num)
			redirect_to poem_path(poem)
		end
		#redirect to error
	end 
	
	def new
		@twitter_handles = []
		twitter_handles = TwitterHandle.all.order(:handle)
		twitter_handles.each do |th|
			if th.tweets.count > 10
				@twitter_handles.push(th)
			end
		end
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

	private

	def poem_params
		params.require(:poem)
	end

	def twitter_handle_params
		params.require(:twitter_handle).permit(:handle)
	end

end
