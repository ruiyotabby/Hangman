require 'yaml'

class Hangman
  attr_accessor :word, :count

  def start
    print 'Welcome to Hangman. Hangman is a guessing game for two or more players. One player thinks of a word, phrase '
    print 'or sentence and the other(s) tries to guess it by suggesting letters within a certain number of guesses. '
    @incorrect_letters = []
    @word = random_word
    puts 'You will have 8 incorrect guesses. A word has been chosen, try to guess it. Goodluck.'
    @count = 8
    @guess = ''
    word.length.times { @guess.concat('_ ') }
    puts check_input
  end

  def check_input
    while count >= 1
      print 'Enter a letter which you think is in the word: (Press 1 to save)'
      letter = gets.chomp.downcase[0]
      return save if letter == '1'

      puts "Incorrect letters chosen are #{@incorrect_letters}" if @incorrect_letters.length.positive?
      return check_letter(letter) if word.include?(letter) == false || letter == nil.to_s

      @guess = update_guess(letter)
      return "You won! The word was '#{word}'" unless @guess.include?('_')

      puts @guess
    end
    return 'You lost as you ran out of incorrect guesses.' if count.zero?
  end

  def save
    yaml = YAML.dump(self)
    File.open('saved.yaml', 'w') { |f| f.write(yaml) }
    exit
  end

  def check_letter(letter)
    @incorrect_letters << letter
    @count -= 1
    puts "The letter chosen was not in the word, you have #{count} incorrect guesses left."
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
