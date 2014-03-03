class LikesController < ApplicationController
	def create
		like = like_poem(poem)
		@like = like.poem.user(:id)
		@like.save
	end

	def dislike 
		@like = Like.find(params[:id])	
		@like.destroy
	end

	def show
		@like = Like.find(params[:id])
		@like.all
	end
end