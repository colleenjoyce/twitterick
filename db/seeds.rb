require 'twitter'

th = TwitterHandle.all
th.each do |handle|
	th.name = client.user(handle.handle).name
	th.save
end