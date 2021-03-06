class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable 
         :twitter_handle_id

  has_many :twitter_handles
  
  has_many :likes

  has_many :poems, :through => :likes

end
