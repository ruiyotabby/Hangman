class Hangman
  def start
    print 'Welcome to Hangman. Hangman is a guessing game for two or more players. One player thinks of a word, phrase '
    print 'or sentence and the other(s) tries to guess it by suggesting letters within a certain number of guesses. '
    word = random_word
    
  end

  def random_word
    word = File.open('english.txt', 'r') { |element| element.read }.split("\n").sample
    return random_word if word.length < 5 || word.length > 12

    word
  end
end

Hangman.new.start
