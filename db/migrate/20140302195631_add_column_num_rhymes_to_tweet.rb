class AddColumnNumRhymesToTweet < ActiveRecord::Migration
  def change
  	 add_column :tweets, :num_rhymes, :integer
  	 add_index :tweets, :num_rhymes
  	 add_index :tweets, :num_syllables	
  end
end
