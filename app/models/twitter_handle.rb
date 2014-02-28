class TwitterHandle < ActiveRecord::Base
	has_many :tweets 
	belongs_to :user 

	validates :handle, uniqueness: true
end
