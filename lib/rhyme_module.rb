require 'open-uri'

class RhymingWords
	def self.get_rhymes(word)
		rhymes = []
		doc_perfect_rhymes = Nokogiri::HTML(open("http://www.rhymezone.com/r/rhyme.cgi?Word=#{word}&typeofrhyme=perfect")).css("a")
		doc_near_rhymes = Nokogiri::HTML(open("http://www.rhymezone.com/r/rhyme.cgi?Word=#{word}&typeofrhyme=nry")).css("a")
		near_rhyme = ""
		doc_near_rhymes.each do |link|
			if(link["href"][0]=="d" && link["href"][1]== "=")
				near_rhyme = link["href"]
				near_rhyme = near_rhyme[2..near_rhyme.length].gsub("_", " ")
				break
			end
		end
		doc_perfect_rhymes.each do |link|
			if (link["href"][0]=="d" && link["href"][1] == "=")
				word = link["href"]
				word = word[2..word.length].gsub("_", " ")
				if(word == near_rhyme)
					break
				end
				rhymes.push(word)
			end
		end
		rhymes
	end

	def self.get_num_rhymes(word)
		get_rhymes(word).count
	end
end 

