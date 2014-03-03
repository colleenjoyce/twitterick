require 'twitter'
require 'open-uri'

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

def handle_check(handle)
	twitter_handle = nil
	#if handle is not blank 
	if handle != ""
		#strips @ sign from handle 
		if (handle[0] == "@")
			handle = handle[1..handle.length]
		end
		#if twitter handle is in db already 
		if (twitter_handle = TwitterHandle.find_by_handle(handle))
			# if handle was searched in last 24 hrs don't check twitter
			if ( twitter_handle.last_searched && (Time.new.to_i - twitter_handle.last_searched.to_i)/86400 > 1) 
				tweets = get_all_tweets(handle, twitter_handle.tweets.last.tweet_status_num)
				push_tweets(twitter_handle.id, tweets)
			end
		else #twitter handle is not in db
			begin # search and retrieve tweets from twitter for given handle  
				tweets = get_all_tweets(handle)
				# if handle is found on twitter, create handle in db (handle is legitimate twitter handle)
				twitter_handle = TwitterHandle.create(handle: handle, last_searched: Time.new)
				# for each tweet found, create Tweet in db 
				push_tweets(twitter_handle.id, tweets)
			rescue
			end
		end
	end
	return twitter_handle
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

handle_check("rihanna")
handle_check("justinbieber")
handle_check("barackobama")
handle_check("edforever")
handle_check("SaraKSilverman")
handle_check("chrisrock")
handle_check("lenadunham")
handle_check("KevinHart4real")
handle_check("ConanOBrien")
handle_check("funnyordie")
handle_check("KimKardashian")
handle_check("BeingLarryDavid")
handle_check("JerrySeinfeld")
handle_check("louisck")
handle_check("JimCarrey")
handle_check("OfficialALT")
handle_check("chelseahandler")
handle_check("jimmyfallon")
handle_check("rustyrockets")
handle_check("katyperry")
handle_check("kanyewest")
handle_check("ActuallyNPH")
handle_check("StephenAtHome")
handle_check("shitgirlssay")
handle_check("_ShitNobodySays")
handle_check("sosadtoday")
handle_check("azizansari")
handle_check("rickygervais")
handle_check("mindykaling")
handle_check("DannyDeVito")
handle_check("johnlegend")
handle_check("SethMacFarlane")
handle_check("danieltosh")
handle_check("SteveMartinToGo")
handle_check("charliesheen")
handle_check("kathygriffin")
handle_check("JimGaffigan")
handle_check("hodgman")
handle_check("EugeneMirman")
handle_check("stephenfry")
handle_check("ZooeyDeschanel")
handle_check("aplusk")
handle_check("ParisHilton")
handle_check("RealTracyMorgan")
handle_check("eddieizzard")
handle_check("nerdist")
handle_check("ladygaga")
handle_check("shakira")
handle_check("jtimberlake")
handle_check("taylorswift13")
handle_check("britneyspears")
handle_check("BrunoMars")
handle_check("AvrilLavigne")
handle_check("NICKIMINAJ")
handle_check("MileyCyrus")
handle_check("aliciakeys")
handle_check("Pink")
handle_check("SnoopDogg")
handle_check("Ludacris")
handle_check("OfficialOzzy")
handle_check("llcoolj")
handle_check("deadmau5")
handle_check("diplo")
handle_check("BillGates")
handle_check("lindsaylohan")
handle_check("CraigyFerg")
handle_check("rainnwilson")










