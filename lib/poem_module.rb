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

	def construct_poem(handles)
puts "start construction"
		# handles is an array of valid twitter handle ids
		poem = []
		rhymes_a = {}
		rhymes_b = {}
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

			t = Tweet.where(twitter_handle_id: handles[handle_index])










			# iterate over array by adding by one
			handle_index += 1 	
		end		
	end 
end 
