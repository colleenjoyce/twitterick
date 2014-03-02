# require 'twitter'
# require 'numbers_and_words'

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

# @tweets = get_all_tweets("")

# @people = Hash.new 
# @people["justinbieber"] = get_all_tweets("justinbieber")
# @people["rainnwilson"] = get_all_tweets("rainnwilson")
# @people["barackobama"] = get_all_tweets("barackobama")


# @people.each do |person|
# 	person.each do |tweet|
# 	Tweet.create(
# 		text: tweet.text, 
# 		twitter_handle_id: tweet.user.screen_name,
# 		tweet_status_url: "https://twitter.com" + tweet.url.path, 
# 		tweet_status_num: tweet.id,
# 		last_word: tweet.text.gsub(/[^\s\or\w]/,"").split(" ").last
# 	)
# end
# end

# @tweets = nil
# begin
# 	@tweets = get_all_tweets("###")
# rescue Exception => e
# 	puts e
# end

	def parse_json(url)
		JSON.parse(HTTParty.get(url).body)
	end

	def get_rhymes(word)
		url = "http://rhymebrain.com/talk?function=getRhymes&word=#{word}"
		return parse_json(url)
	end




	