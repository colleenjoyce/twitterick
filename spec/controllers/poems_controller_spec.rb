require 'spec_helper'

describe PoemsController do

	before do
		@user = User.create(email: "i@example.com", password: "password") 
		@th = TwitterHandle.create(handle: "justinbieber", name: "justin bieber")
		@tweet1 = Tweet.create(text: "tweet1", num_syllables: 1, num_rhymes: 1, tweet_status_url: "http://twitter.com", tweet_status_num: 1, twitter_handle_id: @th.id)
		@tweet2 = Tweet.create(text: "tweet2", num_syllables: 1, num_rhymes: 1, tweet_status_url: "http://twitter.com", tweet_status_num: 1, twitter_handle_id: @th.id)
		@tweet3 = Tweet.create(text: "tweet3", num_syllables: 1, num_rhymes: 1, tweet_status_url: "http://twitter.com", tweet_status_num: 1, twitter_handle_id: @th.id)
		@tweet4 = Tweet.create(text: "tweet4", num_syllables: 1, num_rhymes: 1, tweet_status_url: "http://twitter.com", tweet_status_num: 1, twitter_handle_id: @th.id)
		@tweet5 = Tweet.create(text: "tweet5", num_syllables: 1, num_rhymes: 1, tweet_status_url: "http://twitter.com", tweet_status_num: 1, twitter_handle_id: @th.id)
		@poem = Poem.create()
		@poem_tweet1 = PoemTweet.create(poem_id: @poem.id, tweet_id: @tweet1.id, line_num: 0)
		@poem_tweet2 = PoemTweet.create(poem_id: @poem.id, tweet_id: @tweet2.id, line_num: 1)
		@poem_tweet3 = PoemTweet.create(poem_id: @poem.id, tweet_id: @tweet3.id, line_num: 2)
		@poem_tweet4 = PoemTweet.create(poem_id: @poem.id, tweet_id: @tweet4.id, line_num: 3)
		@poem_tweet5 = PoemTweet.create(poem_id: @poem.id, tweet_id: @tweet5.id, line_num: 4)
	
		sign_in :user, @user
	end 



	describe "GET #index" do 
		it "renders the index template" do 
			get :INDEX
			expect(response).to render_template("index")
		end

	end


	# describe "POST #create" do 
	# 	it "shows a list of twitter user handles" do
	# 		get :POST

	# 	end
	# end



end
