class Poem < ActiveRecord::Base
	belongs_to :poem_tweet 
	belongs_to :poem through: :poem_tweet
end
