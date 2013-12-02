class Wordlist
  attr_reader :list
  
  def initialize(list)
    @list = File.readlines(file).map(&:chomp)
  end
  
  def by_word_length(max_length = nil)
    by_length = Hash.new { |h,k| h[k] = {} }
    
    @list.each do |word|
      length = word.length
      next if max_length && length > max_length
      
      by_length[length][word] = true
    end
    
    by_length
  end
  
  def subwords_from_length(length)
    start = Time.now
    
    words = by_word_length(length)
    candidates = filter_words(words, length)
    pairs = find_pairs(candidates, words[length], length)
    
    run_time = (Time.now - start).round(2)
    
    puts "There are #{pairs.length} winning combinations."
    puts "Runtime: #{run_time} seconds."
    
    pairs
  end
  
  private
  
    def filter_words(words, length)
      filtered = {}
      [:start, :end].each do |anchor| 
        filtered[anchor] = Hash.new { |h,k| h[k] = {} }
      end 
    
      words[length].each do |word, _v|
        filtered.keys.each do |anchor| 
          range = (anchor == :start) ? (1...length) : (-(length - 1)..-1)
    
          range.each do |i|
            key = (anchor == :start) ? i : -i
            subword = (anchor == :start) ? word[0...i] : word[i..-1]
            filtered[anchor][key][subword] = true if words[key][subword]
          end
        end
      end
      puts "Filtering complete."

      filtered
    end
    
    def find_pairs(candidates, checks, lengths)
      winners = {}
  
      (1...length).each do |sub_length|
        pair_length = length - sub_length
        
        candidates[:start][sub_length].each do |word, _v|
          candidates[:end][pair_length].each do |other_word, _v|
            candidate = word + other_word
            winners[[word, other_word]] = candidate if checks[candidate]
          end
        end
        
      end
      puts "Pairing complete."
      
      winners
    end
end