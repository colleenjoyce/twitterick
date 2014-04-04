  class String
    def syllable_count
      consonants = "bcdfghjklmnpqrstvwxz"
      vowels = "aeiouy"
      processed = self.downcase
      numbers = processed.scan(/[\d+[\,*]]+/)
      processed.gsub!(/[\d+[\,*]]+/, " ")
      numbers.each do |number|
      number.gsub!(",", "")
      processed += " " + I18n.with_locale(:en) { number.to_i.to_words }
    end

    suffix_bonus = 0

    if processed.match(/ly$/)
      suffix_bonus = 1
      processed.gsub!(/ly$/, "")
    end
    
    if processed.match(/[a-z]ed$/)
        # Not counting "ed" as an extra symbol. 
        # So 'blessed' is assumed to be said as 'blest'
      suffix_bonus = 0 
      processed.gsub!(/ed$/, "")
    end

      processed.gsub!(/iou|eau|ai|au|ay|ea|ee|ei|oa|oi|oo|ou|ui|oy/, "@") #vowel combos
      processed.gsub!(/qu|ng|ch|rt|[#{consonants}h]/, "=") #consonant combos
      processed.gsub!(/[#{vowels}@][#{consonants}=]e$/, "@|") # remove silent e
      processed.gsub!(/[#{vowels}]/, "@") #all remaining vowels will be counted
      return processed.count("@") + suffix_bonus
      end
  end
