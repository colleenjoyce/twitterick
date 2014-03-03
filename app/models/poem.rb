class Poem < ActiveRecord::Base
	has_many :poem_tweets 
	has_many :tweets, through: :poem_tweets
	has_many :likes 
	has_many :users, :through => :likes
end
