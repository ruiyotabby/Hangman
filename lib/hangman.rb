require 'yaml'

class Hangman
  attr_accessor :word, :count, :read_file

  def initialize
    @incorrect_letters = []
    @word = random_word
    @count = 8
    @guess = ''
    @read_file = File.open('saved.yaml', 'r') { |f| f.read }
  end

  def start
    print 'Welcome to Hangman. Hangman is a guessing game for two or more players. One player thinks of a word, phrase '
    print 'or sentence and the other(s) tries to guess it by suggesting letters within a certain number of guesses. '
    puts 'You will have 8 incorrect guesses. A word has been chosen, try to guess it. Goodluck.'
    word.length.times { @guess.concat('_ ') }
    print "Press '1' to load game " if read_file.length > 1
    input = gets.chomp if read_file.length > 1
    load if input == '1'
    puts check_input
  end

  def check_input
    while count >= 1
      print "Enter a letter which you think is in the word: (Press '1' to save)"
      letter = gets.chomp.downcase[0]
      return save if letter == '1'

      puts "Incorrect letters chosen are #{@incorrect_letters}" if @incorrect_letters.length.positive?
      return check_letter(letter) if word.include?(letter.to_s) == false || letter == nil.to_s

      @guess = update_guess(letter)
      unless @guess.include?('_')
        File.open('saved.yaml', 'w') { |f| f.write '' }
        return "You won! The word was '#{word}'"
      end

      puts @guess
    end
    return 'You lost as you ran out of incorrect guesses.' if count.zero?
  end

  def save
    yaml = YAML.dump({
      incorrect_letters: @incorrect_letters,
      word: @word,
      count: @count,
      guess: @guess
    })
    File.open('saved.yaml', 'w') { |f| f.write(yaml) }
    exit
  end

  def load
    yaml = File.open('saved.yaml', 'r') { |f| f.read }
    obj = Psych.unsafe_load(yaml)
    @incorrect_letters = obj[:incorrect_letters]
    @word = obj[:word]
    @count = obj[:count].to_i
    @guess = obj[:guess]
  end

  def check_letter(letter)
    @incorrect_letters << letter
    @count -= 1
    puts "The letter chosen was not in the word, you have #{count} incorrect guesses left."
    puts @guess
    check_input
  end

  def update_guess(letter)
    word.chars.each_with_index do |value, index|
      @guess = @guess.split(' ').join
      @guess[index] = value if letter == value
    end
    @guess.split('').join(' ')
  end

  def random_word
    word = File.open('english.txt', 'r') { |element| element.read }.split("\n").sample
    return random_word if word.length < 5 || word.length > 12

    word
  end
end

Hangman.new.start
