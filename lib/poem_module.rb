module PoemConstructor
	def construct_poem(twitter_handle)
		poem = []
		used_rhymes_a = []
		used_rhymes_b = []
		used_twitter_handles_a = []
		used_twitter_handles_b = []
		rhymes_a = []
		rhymes_b = []
		num_syll_a = 8
		num_syll_b = 7
		tweet0 = nil
		tweet1 = nil
		tweet2 = nil
		tweet3 = nil
		tweet4 = nil
		breakout = 30

		#Lines 0, 1, 4
		while (tweet0 == nil || tweet1 == nil || tweet4 == nil)
			if breakout == 0
				return false
			end
			used_rhymes_a = []
			used_twitter_handles_a = []
			begin
				tweet0 = Tweet.where(twitter_handle_id: twitter_handle.id).where("num_rhymes > ?", 0).where("num_syllables > ?", num_syll_a).sample
				used_rhymes_a.push(tweet0.last_word)
				used_twitter_handles_a.push(tweet0.twitter_handle.id)
				rhymes_a = RhymingWords.get_rhymes(tweet0.last_word) 
				tweet1 = Tweet.where(last_word: rhymes_a).where.not(last_word: used_rhymes_a).where.not(twitter_handle_id: used_twitter_handles_a).where(num_syllables: num_syll_a).sample
				used_rhymes_a.push(tweet1.last_word)
				used_twitter_handles_a.push(tweet1.twitter_handle.id)
				tweet4 = Tweet.where(last_word: rhymes_a).where.not(last_word: used_rhymes_a).where.not(twitter_handle_id: used_twitter_handles_a).where(num_syllables: num_syll_a).sample
				used_rhymes_a.push(tweet4.last_word)
				used_twitter_handles_a.push(tweet4.twitter_handle.id)
			rescue Exception => e
				puts e.to_s
			end
			breakout -= 1
		end

		breakout = 30
		#Lines 2, 3
		while (tweet2 == nil || tweet3 == nil)
			if breakout == 0
				return false
			end
			used_rhymes_b = used_rhymes_a
			used_twitter_handles_b = used_twitter_handles_a
			begin
				tweet2 = Tweet.where("num_rhymes > ?", 0).where.not(last_word: used_rhymes_b).where.not(twitter_handle_id: used_twitter_handles_b).where("num_syllables < ?", num_syll_b).sample
				used_rhymes_b.push(tweet2.last_word)
				used_twitter_handles_b.push(tweet2.twitter_handle.id)
				rhymes_b = RhymingWords.get_rhymes(tweet2.last_word)
				tweet3 = Tweet.where(last_word: rhymes_b).where.not(last_word: used_rhymes_b).where.not(twitter_handle_id: used_twitter_handles_b).where(num_syllables: num_syll_b).sample
				used_rhymes_b.push(tweet3.last_word)
				used_twitter_handles_b.push(tweet3.twitter_handle.id)
			rescue Exception => e
				puts e.to_s
			end
			breakout -= 1
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