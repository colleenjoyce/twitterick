module PoemConstructor

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
puts handle + " :before last day search " + ((Time.new.to_i - th.last_searched.to_i)/86400).to_s
					if ( th.last_searched && (Time.new.to_i - th.last_searched.to_i)/86400 > 1) 
puts handle + " :inside last day search: " 
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
	
	end # END HANDLE CHECK 

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


	def iterate_handles(handle_index, handles)
		handle_index += 1
		if (handle_index == handles.length)
			# set handle array index to 0 (beginning of array) to restart iteration 
			handle_index = 0
		end
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
puts "handle_index: " + handle_index.to_s


			#check for poem conditions
puts "line_num" + line_num.to_s
			case line_num
			when 0 # IMPORTANT LINE 
puts "constructing line_num 0"
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables > ?", 7).sample
				#rhymes_a = get_rhymes(tweet.last_word) 
				num_syll_a = tweet.num_syllables

				# stop_while = 20 
				# while (rhymes_a.count < 10 ) 
				# 	tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables > ?", 7).sample
				# 	rhymes_a = get_rhymes(tweet.last_word) 
				# 	num_syll_a = tweet.num_syllables

				# 	if (stop_while == 0)
				# 		#poem construction failed
				# 		return false
				# 	end
				# 	stop_while -= 1
				# end
puts "line_num 0 tweet " + tweet.text
				poem.push(tweet)
			when 1
puts "constructing line_num 1"
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables = ?", num_syll_a).sample


puts "line_num 1 tweet " + tweet.text
				poem.push(tweet)
			when 2 # IMPORTANT LINE - check number of rhymes returned 
puts "constructing line_num 2"
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables < ?", 7).sample
				#Srhymes_b = get_rhymes(tweet.last_word) 
				num_syll_b = tweet.num_syllables

				# stop_while = 20 
				# while (rhymes_b.count < 10 ) 
				# 	tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables < ?", 7).sample
				# 	rhymes_b = get_rhymes(tweet.last_word) 
				# 	num_syll_b = tweet.num_syllables

				# 	if (stop_while == 0)
				# 		#poem construction failed
				# 		return false
				# 	end
				# 	stop_while -= 1
				# end
				poem.push(tweet)
puts "line_num 2 tweet " + tweet.text
			when 3
puts "constructing line_num 3"

				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables = ?", num_syll_b).sample
				poem.push(tweet)
puts "line_num 3 tweet " + tweet.text
			when 4		
puts "constructing line_num 4"
				tweet = Tweet.where(twitter_handle_id: handles[handle_index]).where("num_syllables = ?", num_syll_a).sample
				poem.push(tweet)
puts "line_num 4 tweet " + tweet.text
			end

			# iterate over array by adding by one
			handle_index = iterate_handles(handle_index, handles)
		end		
puts "Poem: "
poem.each do |tweet|
	puts tweet.text 
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
