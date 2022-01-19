class BadWordDetector
  @bad_words = [/tonto/i, /cag[óo]n/i, /mierda/i, /puta/i]

  def detector(string)
    @bad_words.map do |bad_word|
      string.gsub!(bad_word, '****')
    end
  end
end