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
end 