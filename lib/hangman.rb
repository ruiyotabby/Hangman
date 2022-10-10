class Hangman
  def start
    print 'Welcome to Hangman. Hangman is a guessing game for two or more players. One player thinks of a word, phrase '
    print 'or sentence and the other(s) tries to guess it by suggesting letters within a certain number of guesses. '
    word = random_word
    puts 'You will have 8 incorrect guesses. A word has been chosen, try to guess it. Goodluck.'
    n = 8
    guess = ''
    word.length.times { guess.concat('_ ') }
    puts check_input(guess, n, word)
  end

  def check_input(guess, n, word)
    while n >= 1
      print "\nEnter a letter which you think is in the word: "
      letter = gets.chomp.downcase
      if word.include?(letter) == false || letter == nil.to_s
        n -= 1
        return check_input(guess, n, word)
      end
      guess = update_guess(guess, word, letter)
      return "You won! The word was '#{word}'" unless guess.include?('_')

      puts guess
    end
    return 'You ran out of guesses' if n.zero?
  end

  def update_guess(guess, word, letter)
    word.chars.each_with_index do |value, index|
      guess = guess.split(' ').join
      guess[index] = value if letter == value
    end
    guess.split('').join(' ')
  end

  def random_word
    word = File.open('english.txt', 'r') { |element| element.read }.split("\n").sample
    return random_word if word.length < 5 || word.length > 12

    word
  end
end

Hangman.new.start
