class Likes < ActiveRecord::Base
	belongs_to :user 
	belongs_to :poem
end
