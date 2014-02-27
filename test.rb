# require 'twitter'
# require 'httparty'
# require 'numbers_and_words'

# # @client = Twitter::REST::Client.new do |config|
# # 	config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
# # 	config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
# # 	config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
# # 	config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
# # end

# # def collect_with_max_id(collection=[], max_id=nil, &block)
# # 	response = yield max_id
# # 	collection += response
# # 	response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
# # end

# # def get_all_tweets(user)
# # 	collect_with_max_id do |max_id|
# # 		options = {:count => 200, :include_rts => true}
# # 		options[:max_id] = max_id unless max_id.nil?
# # 		@client.user_timeline(user, options)
# # 	end
# # end

# # #@tweets = get_all_tweets("")

# # def parse_json(url)
# # JSON.parse(HTTParty.get(url).body)
# # end

# # url = "http://rhymebrain.com/talk?function=getRhymes&word=hello"
# # @rhymes = parse_json(url)

# class String
  

#   def syllable_count
#     consonants = "bcdfghjklmnpqrstvwxz"
#     vowels = "aeiouy"
#     processed = self.downcase
    
#     numbers = processed.scan(/[\d+[\,*]]+/)
# 	processed.gsub!(/[\d+[\,*]]+/, " ")
# 	numbers.each do |number|
# 		number.gsub!(",", "")
# 		processed += " " + I18n.with_locale(:en) { number.to_i.to_words }
# 	end
    
#     suffix_bonus = 0
#     #puts "*** 0 #{processed}"
#     if processed.match(/ly$/)
#       suffix_bonus = 1
#       processed.gsub!(/ly$/, "")
#     end
#     if processed.match(/[a-z]ed$/)
#       # Not counting "ed" as an extra symbol. 
#       # So 'blessed' is assumed to be said as 'blest'
#       suffix_bonus = 0 
#       processed.gsub!(/ed$/, "")
#     end
#     #puts "*** 1 #{processed}"
#     processed.gsub!(/iou|eau|ai|au|ay|ea|ee|ei|oa|oi|oo|ou|ui|oy/, "@") #vowel combos
#     #puts "*** 2 #{processed}"
#     processed.gsub!(/qu|ng|ch|rt|[#{consonants}h]/, "=") #consonant combos
#     #puts "*** 3 #{processed}"
#     processed.gsub!(/[#{vowels}@][#{consonants}=]e$/, "@|") # remove silent e
#     #puts "*** 4 #{processed}"
#     processed.gsub!(/[#{vowels}]/, "@") #all remaining vowels will be counted
#     #puts "*** 5 #{processed}"
#     return processed.count("@") + suffix_bonus
#   end
  
# end






