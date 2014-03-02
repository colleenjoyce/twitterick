module RhymingWords
	def get_rhymes(word)
		rhymes = []
		doc = Nokogiri::HTML(open("http://www.rhymezone.com/r/rhyme.cgi?Word=#{word}&typeofrhyme=perfect"))
		doc.css("a").each do |link|
			if (link["href"][0]=="d" && link["href"][1] == "=")
			word = link["href"]
			rhymes.push(word[2..word.length])
			end
		end
		rhymes
	end

	def get_num_rhymes(word)
		get_rhymes(word).count
	end 

	# BACK-UP CODE 
	# def parse_json(url)
	# 	JSON.parse(HTTParty.get(url).body)
	# end

	# def get_rhymes(word)
	# 	url = "http://rhymebrain.com/talk?function=getRhymes&word=#{word}"
	# 	rhymes = []
	# 	parse_json(url).each do |rhyme|
	# 		rhymes.push(rhyme["word"])		
	# 	end
	# 	return rhymes 
	# end


end 

