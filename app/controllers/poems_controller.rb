require 'twitter_api'
require 'poem_module'
require 'rhyme_module'

class PoemsController < ApplicationController
include TwitterApi
include PoemConstructor

	def index
		
	end

	def create
		@poem = construct_poem(handle_check)
		redirect_to poem_path(@poem)
	end 
	
	def new

	end

	def show 
		@poem = Poem.find(params[:id])
	end

	private

	def poem_params
		params.require(:poem)
	end
end
