class ChangeColumnType < ActiveRecord::Migration
  def change
  	change_column :tweets, :twitter_handle_id, :integer   
  end
end
