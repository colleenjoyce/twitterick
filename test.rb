# require 'twitter'
# require 'numbers_and_words'
require 'Nokogiri'


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

	# def parse_json(url)
	# 	JSON.parse(HTTParty.get(url).body)
	# end

	# def get_rhymes(word)
	# 	url = "http://rhymebrain.com/talk?function=getRhymes&word=#{word}"
	# 	return parse_json(url)
	# end


class RhymingWords
	def self.get_rhymes(word)
		rhymes = []
		doc = Nokogiri::HTML(open("http://www.rhymezone.com/r/rhyme.cgi?Word=#{word}&typeofrhyme=perfect"))
		doc.css("a").each do |link|
			if (link["href"][0]=="d" && link["href"][1] == "=")
			word = link["href"]
			rhymes.push(word[2..word.length])
			end
		end
		rhymes
	end

	def self.get_num_rhymes(word)
		get_rhymes(word).count
	end 

	# BACK-UP CODE 
	# def self.parse_json(url)
	# 	JSON.parse(HTTParty.get(url).body)
	# end

	# def self.get_rhymes(word)
	# 	url = "http://rhymebrain.com/talk?function=getRhymes&word=#{word}"
	# 	rhymes = []
	# 	self.parse_json(url).each do |rhyme|
	# 		rhymes.push(rhyme["word"])		
	# 	end
	# 	return rhymes 
	# end


end 

puts RhymingWords.get_num_rhymes("hello").to_s 



	