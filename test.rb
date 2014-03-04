require 'twitter'
require 'Nokogiri'
require 'open-uri'
require 'httparty'

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

def get_rhymes(word)
	rhymes = []
	doc_perfect_rhymes = Nokogiri::HTML(open("http://www.rhymezone.com/r/rhyme.cgi?Word=#{word}&typeofrhyme=perfect")).css("a")
	doc_near_rhymes = Nokogiri::HTML(open("http://www.rhymezone.com/r/rhyme.cgi?Word=#{word}&typeofrhyme=nry")).css("a")
	near_rhyme = ""
	doc_near_rhymes.each do |link|
		if(link["href"][0]=="d" && link["href"][1]== "=")
			near_rhyme = link["href"]
			near_rhyme = near_rhyme[2..near_rhyme.length].gsub("_", " ")
			break
		end
	end
	doc_perfect_rhymes.each do |link|
		if (link["href"][0]=="d" && link["href"][1] == "=")
			word = link["href"]
			word = word[2..word.length].gsub("_", " ")
			if(word == near_rhyme)
				break
			end
			rhymes.push(word)
		end
	end
	rhymes
end

def get_num_rhymes(word)
	get_rhymes(word).count
end 

def check_twitter_handle(handle)
	client = get_twitter_client
	twitter_handle = nil
	begin
		twitter_handle = client.user(handle)
	rescue
	end
	twitter_handle
end

@client = get_twitter_client
@js = get_all_tweets("justinbieber", "439653103034314753")
@ja = get_all_tweets("justinbieber")


