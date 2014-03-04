class TwitterHandlesController < ApplicationController
	def new
	end

	def create		
		twitter_handle = TwitterHandle.create(twitter_handle_params)
		if twitter_handle.id
			redirect_to root_url, notice: "Thanks for submitting a new Twitter handle. Be sure to check back to see it featured in a poem."
		else
			redirect_to twitter_handles_new_path, alert: "Sorry! There was a problem with the twitter handle submitted."
		end
	end
	def twitter_handle_params
		params.require(:twitter_handle).permit(:handle)
	end
end