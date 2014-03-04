class TwitterHandle < ActiveRecord::Base
	has_many :tweets 
	belongs_to :user 

	validates :handle, uniqueness: { case_sensitive: false }, presence: true 
end
