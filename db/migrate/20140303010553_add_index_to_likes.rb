class AddIndexToLikes < ActiveRecord::Migration
  def change
  	add_index :likes, :poem_id
  	add_index :likes, :user_id
  end
end
