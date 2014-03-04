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
		poem = []
		used_rhymes_a = []
		used_rhymes_b = []
		used_twitter_handles_a = []
		used_twitter_handles_b = []
		rhymes_a = []
		rhymes_b = []
		tweet0 = nil
		tweet1 = nil
		tweet2 = nil
		tweet3 = nil
		tweet4 = nil

		#Lines 0, 1, 4
		while (tweet0 == nil || tweet1 == nil || tweet4 == nil)
			used_rhymes_a = []
			used_twitter_handles_a = []
			begin
				tweet0 = Tweet.where(twitter_handle_id: twitter_handle.id).where("num_rhymes > ?", 5)
				if (tweet0.count < 10)
					return false
				else
					tweet0 = tweet0.sample
				end
				used_rhymes_a.push(tweet0.last_word)
				used_twitter_handles_a.push(tweet0.twitter_handle.handle)
				rhymes_a = RhymingWords.get_rhymes(tweet0.last_word) 
				tweet1 = Tweet.where(last_word: rhymes_a).where.not(last_word: used_rhymes_a).where.not(twitter_handle_id: used_twitter_handles_a).sample
				used_rhymes_a.push(tweet1.last_word)
				used_twitter_handles_a.push(tweet1.twitter_handle.id)
				tweet4 = Tweet.where(last_word: rhymes_a).where.not(last_word: used_rhymes_a).where.not(twitter_handle_id: used_twitter_handles_a).sample
				used_rhymes_a.push(tweet4.last_word)
				used_twitter_handles_a.push(tweet4.twitter_handle.id)
			rescue Exception => e
				puts e.to_s
			end
		end

		#Lines 2, 3
		while (tweet2 == nil || tweet3 == nil)
			used_rhymes_b = []
			used_twitter_handles_b = []
			begin
				tweet2 = Tweet.where("num_rhymes > ?", 5).where.not(last_word: used_rhymes_a).where.not(twitter_handle_id: used_twitter_handles_a).sample
				used_rhymes_b.push(tweet2.last_word)
				used_twitter_handles_b.push(tweet2.twitter_handle.handle)
				rhymes_b = RhymingWords.get_rhymes(tweet2.last_word)
				tweet3 = Tweet.where(last_word: rhymes_b).where.not(last_word: used_rhymes_a).where.not(twitter_handle_id: used_twitter_handles_a)
								.where.not(last_word: used_rhymes_b).where.not(twitter_handle_id: used_twitter_handles_b).sample
				used_rhymes_b.push(tweet3.last_word)
				used_twitter_handles_b.push(tweet3.twitter_handle.handle)
			rescue Exception => e
				puts e.to_s
			end
		end

		poem.push(tweet0)
		poem.push(tweet1)
		poem.push(tweet2)
		poem.push(tweet3)
		poem.push(tweet4)
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
