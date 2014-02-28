# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Tweet.create(text: "At this point, I don't know what my milkshake brings.", twitter_handle_id: "@kelleydmcguire", last_word: "brings", twitter_status_url: "https://twitter.com/kelleydmcguire/statuses/317468526514413569")
# Tweet.create(text: "Wake up to the most ridiculous texts some mornings...", twitter_handle_id: "CharlotteLegge", last_word: "mornings", twitter_status_url: "https://twitter.com/CharlotteLegge/statuses/316525495984455680")
# Tweet.create(text: "Bored anything to do ?", twitter_handle_id: "Shurog_AB", last_word: "do", twitter_status_url: "https://twitter.com/Shurog_AB/statuses/316583637418127360")
# Tweet.create(text: "Stuff too do ! Stuff to doo .", twitter_handle_id: "X_WeCousins", last_word: "doo", twitter_status_url: "https://twitter.com/X_WeCousins/status/317071401456631808")
# Tweet.create(text: "When I listen to drake I text with my feelings", twitter_handle_id: "@iNBA_2k13", last_word: "feelings", twitter_status_url: "https://twitter.com/iNBA_2k13/statuses/316238467170443264")

# Tweet.create(text: "Nobody wants to talk to me... Night then.", twitter_handle_id: "_CountryBunkin", last_word: "then", twitter_status_url: "https://twitter.com/_CountryBunkin/statuses/315705014616195072")
# Tweet.create(text: "Swear I just fell in love ALL over again......", twitter_handle_id: "since97___", last_word: "again", twitter_status_url: "https://twitter.com/since97___/status/315365548655521792")
# Tweet.create(text: "and yes i just said 'ass'", twitter_handle_id: "iimaniixoxo", last_word: "ass", twitter_status_url: "https://twitter.com/iimaniixoxo/statuses/315339539776425984")
# Tweet.create(text: "I Was K.O. In Class", twitter_handle_id: "YungKelon100", last_word: "Class", twitter_status_url: "https://twitter.com/YungKelon100/statuses/316914052121104386")
# Tweet.create(text: "me find get for its one to get can not it when", twitter_handle_id: "since97___", last_word: "again", twitter_status_url: "https://twitter.com/since97___/status/315365548655521792")

# # BAD TWEETS 
# Tweet.create(text: "http://google.com")
# Tweet.create(text: "@justinbeiber")
# Tweet.create(text: "#justinbeiber")
# Tweet.create(text: "toy")

# User.create(email: "caroline@example.com", twitter_handle_id: "@ccaarroolliinee")

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

@tweets = get_all_tweets("ccaarroolliinee")

@tweets.each do |tweet|
	Tweet.create(
		text: tweet.text, 
		twitter_handle_id: tweet.user.screen_name,
		tweet_status_url: "https://twitter.com" + tweet.url.path, 
		tweet_status_num: tweet.id,
		last_word: tweet.text.gsub(/[^\s\or\w]/,"").split(" ").last
	) 
end



