require 'twitter_api'

namespace :tweets do 
	include TwitterApi
	task :update_tweets => :environment do
  		update_tweets
  	end
end