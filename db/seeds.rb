require 'twitter'
client = get_twitter_client
th = TwitterHandle.all
th.each do |handle|
	handle.name = client.user(handle.handle).name
	handle.save
end