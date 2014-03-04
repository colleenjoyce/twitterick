require 'twitter_api'
class TwitterHandleValidation < ActiveModel::Validator
	include TwitterApi
	def validate(twitter_handle)
		if (twitter_handle.handle[0] == "@")
			twitter_handle.handle = twitter_handle.handle[1..twitter_handle.handle.length]
		end
		twitter_handle.handle = twitter_handle.handle.downcase
		if th = check_twitter_handle(twitter_handle.handle)
			twitter_handle.name = th.name
		else
			twitter_handle.errors[:base] << "This handle is not a valid Twitter handle"
			return nil
		end
	end
end

class TwitterHandle < ActiveRecord::Base

	has_many :tweets 
	belongs_to :user 

	validates_with TwitterHandleValidation
	validates :handle, uniqueness: true, presence: true 
end