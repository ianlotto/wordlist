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
    
  end
  
  private
  
    def filter_words
    
    end
    
    def find_pairs
      
    end
end