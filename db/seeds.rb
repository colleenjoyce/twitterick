
# # BAD TWEETS 
# Tweet.create(text: "http://google.com")
# Tweet.create(text: "@justinbeiber")
# Tweet.create(text: "#justinbeiber")
# Tweet.create(text: "toy")

# User.create(email: "caroline@example.com", twitter_handle_id: "@ccaarroolliinee")

# @client = Twitter::REST::Client.new do |config|
#  	config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
#  	config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
#  	config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
#  	config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
#  end

#  def collect_with_max_id(collection=[], max_id=nil, &block)
# 	response = yield max_id
#  	collection += response
#  	response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
#  end

#  def get_all_tweets(user)
#  	collect_with_max_id do |max_id|
#  	 		options = {:count => 200, :include_rts => true}
# 		options[:max_id] = max_id unless max_id.nil?
#  		@client.user_timeline(user, options)
#  	end
#  end

# @tweets = get_all_tweets("ccaarroolliinee")

# @tweets.each do |tweet|
# 	Tweet.create(
# 		text: tweet.text, 
# 		twitter_handle_id: tweet.user.screen_name,
# 		tweet_status_url: "https://twitter.com" + tweet.url.path, 
# 		tweet_status_num: tweet.id,
# 		last_word: tweet.text.gsub(/[^\s\or\w]/,"").split(" ").last
# 	) 
# end

@poem = Poem.create()

@line1 = PoemTweet.create(poem_id: 1, tweet_id: 7, line_num: 1)
@line2 = PoemTweet.create(poem_id: 1, tweet_id: 19, line_num: 2)
@line3 = PoemTweet.create(poem_id: 1, tweet_id: 3, line_num: 3)
@line4 = PoemTweet.create(poem_id: 1, tweet_id: 35, line_num: 4)
@line5 = PoemTweet.create(poem_id: 1, tweet_id: 12, line_num: 5)











