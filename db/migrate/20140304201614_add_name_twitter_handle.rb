class AddNameTwitterHandle < ActiveRecord::Migration
  def change
  	add_column :twitter_handles, :name, :string
  end
end
