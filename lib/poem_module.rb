module PoemConstructor

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
					tweets = get_all_tweets(handle)
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

	def construct_poem(twitter_handle)
puts "start construction"
		poem = []
		used_rhymes = []
		used_twitter_handles = []
		rhymes_a = []
		rhymes_b = []
		num_syll_a = 8
		num_syll_b = 7

		(0..4).each do |line_num|
			#check for poem conditions
			case line_num

			when 0 # IMPORTANT LINE 
				begin
					# tweet = Tweet.where(twitter_handle_id: twitter_handle.id).where("num_syllables > ?", num_syll_a).where("num_rhymes > ?", 20).sample
					tweet = Tweet.where(twitter_handle_id: twitter_handle.id).where("num_rhymes > ?", 5).sample
					used_rhymes.push(tweet.last_word)
					used_twitter_handles.push(tweet.twitter_handle.handle)
					#num_syll_a = tweet.num_syllables
					rhymes_a = RhymingWords.get_rhymes(tweet.last_word) 				
					poem.push(tweet)
				rescue Exception => e
					puts "line_num 0 " + e.to_s
					return false
				end








			when 1
				begin
					# tweet = Tweet.where(num_syllables: num_syll_a).where(last_word: rhymes_a).where.not(last_word: used_rhymes).where.not(twitter_handle_id: used_twitter_handles).sample
					tweet = Tweet.where(last_word: rhymes_a).where.not(last_word: used_rhymes).where.not(twitter_handle_id: used_twitter_handles).sample
					used_rhymes.push(tweet.last_word)
					used_twitter_handles.push(tweet.twitter_handle.id)
					poem.push(tweet)
				rescue Exception => e
					puts "line_num 1 " + e.to_s
					return false
				end







			when 2 # IMPORTANT LINE
				begin
					# tweet = Tweet.where(twitter_handle_id: twitter_handle.id).where("num_syllables < ?", num_syll_b).where("num_rhymes > ?", 20).sample
					tweet = Tweet.where("num_rhymes > ?", 5).where.not(last_word: used_rhymes).where.not(twitter_handle_id: used_twitter_handles).sample
					used_rhymes.push(tweet.last_word)
					used_twitter_handles.push(tweet.twitter_handle.id)
					#num_syll_b = tweet.num_syllables
					rhymes_b = RhymingWords.get_rhymes(tweet.last_word)
					poem.push(tweet)
				rescue Exception => e
					puts "line_num 2 " + e.to_s
					return false
				end









			when 3
				begin
					# tweet = Tweet.where(num_syllables: num_syll_b).where(last_word: rhymes_b).where.not(last_word: used_rhymes).where.not(twitter_handle_id: used_twitter_handles).sample
					tweet = Tweet.where(last_word: rhymes_b).where.not(last_word: used_rhymes).where.not(twitter_handle_id: used_twitter_handles).sample
					used_rhymes.push(tweet.last_word)
					used_twitter_handles.push(tweet.twitter_handle.id)
					poem.push(tweet)
				rescue Exception => e
					puts "line_num 3 " + e.to_s
					return false
				end







			when 4		
				begin
					#tweet = Tweet.where(num_syllables: num_syll_a).where(last_word: rhymes_a).where.not(last_word: used_rhymes).where.not(twitter_handle_id: used_twitter_handles).sample
					tweet = Tweet.where(last_word: rhymes_a).where.not(last_word: used_rhymes).where.not(twitter_handle_id: used_twitter_handles).sample
					poem.push(tweet)
				rescue Exception => e
					puts "line_num 4 " + e.to_s
					return false
				end
			end









		end		
		save_poem(poem)
	end 

	def save_poem(poem_arr) 	
		poem = Poem.create
		poem_arr.each_with_index do |tweet, index|
			PoemTweet.create(poem_id: poem.id, tweet_id: tweet.id, line_num: index)			
		end
		return poem 
	end 
end 
