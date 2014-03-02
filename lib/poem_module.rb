module Poem

	def handle_check
puts "in handle check"
		handles = Array.new
		params[:handles].each do |handle|
			#if handle is not blank 
			if handle != "" 
				#strips @ sign from handle 
				handle = handle[1..handle.length]
				#if twitter handle is in db already 
				if (th = TwitterHandle.find_by_handle(handle))
puts handle + " :inside handle in db"
					# if handle was searched in last 24 hrs don't check twitter
puts handle + " :before last day search"
					if ( th.last_searched && Time.new.day - th.last_searched.day == 1) 
puts handle + " :inside last day search"
						tweets = get_all_tweets(handle)
						push_tweets(th.id, tweets)
					end
					# handle is legitimate twitter account 
					handles.push(th.id)
				else #twitter handle is not in db
puts handle + " inside handle not in db"
					begin # search, retrieve twitter for tweets by given handle  
						tweets = get_all_tweets(handle)
						# if handle is found on twitter, create handle in db 
						th = TwitterHandle.create(handle: handle, last_searched: Time.new)
						# for each tweet found, create Tweet in db 
						push_tweets(th.id, tweets)
						# handle is legitimate twitter account 
						handles.push(th.id)
						# if there's a problem in begin, rescue here 
					rescue
					end
				end
			end
			return handles 
		end
		# @handles.each do |handle|
		# 	handle.each do |tweet|
		# 	
		# 	end
		# end
		# redirect_to poem_path
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

	def parse_json(url)
		JSON.parse(HTTParty.get(url).body)
	end

	def get_rhymes(word)
		url = "http://rhymebrain.com/talk?function=getRhymes&word=#{word}"
		rhymes = []
		parse_json(url).each do |rhyme|
			rhymes.push(rhyme["word"])		
		end
		return rhymes 
	end

	def construct_poem(handles)
puts "start construction"
		# handles is an array of valid twitter handle ids
		poem = []
		rhymes_a = []
		rhymes_b = []
		num_syll_a = 0
		num_syll_b = 0
		# (i) initialize handle array index
		handle_index = 0 
		(0..4).each do |line_num|
			# secondary loop 
			# if handle array index is equal to the length of the array 
			if (handle_index == handles.length)
				# set handle array index to 0 (beginning of array) to restart iteration 
				handle_index = 0
			end

			#check for poem conditions

			when (line_num == 0) # IMPORTANT LINE 
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables > ?", 7).sample
				rhymes_a = get_rhymes(tweet.last_word) 
				num_syll_a = tweet.num_syllables

				stop_while = 20 
				while (rhymes_a.count < 10 ) 
					tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables > ?", 7).sample
					rhymes_a = get_rhymes(tweet.last_word) 
					num_syll_a = tweet.num_syllables

					if (stop_while == 0)
						#poem construction failed
						return false
					end
					stop_while -= 1
				end
				poem.push(tweet)
			when (line_num == 1)
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables = ?", num_syll_a).sample
			when (line_num == 2) # IMPORTANT LINE - check number of rhymes returned 
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables < ?", 7).sample
				rhymes_b = get_rhymes(tweet.last_word) 
				num_syll_b = tweet.num_syllables

				stop_while = 20 
				while (rhymes_b.count < 10 ) 
					tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables < ?", 7).sample
					rhymes_b = get_rhymes(tweet.last_word) 
					num_syll_b = tweet.num_syllables

					if (stop_while == 0)
						#poem construction failed
						return false
					end
					stop_while -= 1
				end
				poem.push(tweet)
			when (line_num == 3)
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables = ?", num_syll_b).sample
			when (line_num == 4)							
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables = ?", num_syll_a).sample
			end

puts "Tweet with num_syllables > 7 " + t 

			# iterate over array by adding by one
			handle_index += 1 	
		end		
	end 
end 
