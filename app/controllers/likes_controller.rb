class LikesController < ApplicationController
	def create
		@like = Like.create
		@like.value += 1 unless @like.value == 1 
		@like.save 
	end

	def dislike 
		@like.value -= 1 unless @like == -1
		@like.save 
	end

	def show
		@like = Like.find(params[:id])
	end

	def destroy
		@like = Like.find(params[:id])
		@like.destroy
	end
end