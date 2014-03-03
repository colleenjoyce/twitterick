require 'twitter'

module TwitterApi 
	def get_twitter_client
		client = Twitter::REST::Client.new do |config|
			config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
			config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
			config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
			config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
		end
		return client
	end

	def collect_with_max_id(collection=[], max_id=nil, &block)
		response = yield max_id
		collection += response
		response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
	end

	def get_all_tweets(user, since_id=nil)
		client = get_twitter_client
		collect_with_max_id do |max_id|
			options = {:count => 200, :include_rts => false, :exclude_replies => true}
			options[:max_id] = max_id unless max_id.nil?
			if (since_id)
				options[:since_id] = since_id
			end
			client.user_timeline(user, options)
		end
	end
end