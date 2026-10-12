# frozen_string_literal: true

class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  #
  def guess(letter)
    raise ArgumentError if letter.nil?
    raise ArgumentError unless letter.match?(/\A[a-z]\z/i)

    letter = letter.downcase
    if @word.include?(letter)
      return false if @guesses.include?(letter)

      @guesses += letter
    else
      return false if @wrong_guesses.include?(letter)

      @wrong_guesses += letter
    end
    true
  end

  def word_with_guesses
    hidden = +''
    @word.each_char do |c|
      hidden += (@guesses.include?(c) ? c : '-')
    end
    hidden
  end

  def check_win_or_lose
    if @wrong_guesses.length > 6
      :lose
    elsif word_with_guesses == @word
      :win
    else
      :play
    end
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      return http.post(uri, '').body
    end
  end
end
