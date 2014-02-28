class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.integer :num_syllables
      t.integer :twitter_handle_id
      t.string :last_word

      t.timestamps
    end
  end
end
