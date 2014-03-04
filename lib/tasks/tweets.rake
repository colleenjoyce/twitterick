require 'twitter'

namespace :tweets do 
	

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

	def update_tweets
		twitter_handles_with_no_tweets = []
		twitter_handles_with_few_tweets = []
		th = TwitterHandle.all
		th.each do |handle|
			if handle.tweets.count == 0
				twitter_handles_with_no_tweets.push(handle)
			elsif handle.tweets.count > 0 && handle.tweets.count < 100
				twitter_handles_with_few_tweets.push(handle)
			end
		end

		if (twitter_handle = TwitterHandle.find_by_handle(handle))
			if ( twitter_handle.last_searched && (Time.new.to_i - twitter_handle.last_searched.to_i)/86400 > 1) 
				tweets = get_all_tweets(handle, twitter_handle.tweets.last.tweet_status_num)
				push_tweets(twitter_handle.id, tweets)
			end
		else 
			begin  
				tweets = get_all_tweets(handle)
				twitter_handle = TwitterHandle.create(handle: handle, last_searched: Time.new)
				push_tweets(twitter_handle.id, tweets)
			rescue Exception => e
				puts e
			end
		end
	end

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
end