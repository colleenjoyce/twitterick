require 'twitter'
require 'httparty'

@client = Twitter::REST::Client.new do |config|
	config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
	config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
	config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
	config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

def collect_with_max_id(collection=[], max_id=nil, &block)
	response = yield max_id
	collection += response
	response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def get_all_tweets(user)
	collect_with_max_id do |max_id|
		options = {:count => 200, :include_rts => true}
		options[:max_id] = max_id unless max_id.nil?
		@client.user_timeline(user, options)
	end
end

#@tweets = get_all_tweets("")

def parse_json(url)
JSON.parse(HTTParty.get(url).body)
end

url = "http://rhymebrain.com/talk?function=getRhymes&word=hello"
@rhymes = parse_json(url)