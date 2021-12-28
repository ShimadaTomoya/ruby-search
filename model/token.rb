class Token
  def self.ngram_tokens(str, length = 2)
    str_splitted = str.split('')
    result = []
    for i in 0..str_splitted.size-length do
      result.push str_splitted[i...i+length].join
    end
    return result
  end
end