class TwitterHandle < ActiveRecord::Base
	has_many :tweets 
	belongs_to :user 

	validates :handle, uniqueness: true, presence: true 

	before_validation :downcase_handle

	private
	def downcase_handle
		self.handle = self.handle.downcase
	end
end