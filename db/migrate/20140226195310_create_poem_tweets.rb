class CreatePoemTweets < ActiveRecord::Migration
  def change
    create_table :poem_tweets do |t|
      t.integer :poem_id
      t.integer :tweet_id
      t.integer :line_num

      t.timestamps
    end
  end
end
