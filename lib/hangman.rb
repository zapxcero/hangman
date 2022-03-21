# frozen_string_literal: true

class Hangman
  attr_accessor :dictionary, :secret_word, :guess

  def initialize
    @guess = 10
    @game_running = true
    @dictionary = load_dictionary
    @secret_word = random_dictionary
    p @secret_word
    @user_guesses = []
    game
  end

  def load_dictionary
    File.open('dictionary.txt').readlines
  end

  def random_dictionary
    sample_word = @dictionary.sample.chomp
    if sample_word.length >= 5 && sample_word.length <= 12
      sample_word
    else
      random_dictionary
    end
  end

  def hint_secret_word
    puts "Here's the secret word's length and the guesses you've made."
    secret_word.chars.each do |letter|
      if @user_guesses.include? letter
        print " #{letter} "
      else
        print ' _ '
      end
    end
    print "\n"
  end

  def ask_user_guess
    print "\n\nEnter a letter to guess the secret word: "
    letter = gets.chomp
    @user_guesses.push(letter) unless @user_guesses.include? letter
    winner?
  end

  def winner?
    puts "Winner method"
  end

  def game
    puts "Do you want to:\n\n[1]Start a new game\n[2]Resume a saved game?\n\n"
    print 'Enter choice: '
    choice = gets.chomp

    case choice.to_i
    when 1
      loop do
        hint_secret_word
        ask_user_guess
        # ask user to guess
        # if user guess X char, then add it to guesses_he_made
        #
        # to determine if user guessed all words
        # check if @secret_word.chars.includes? @user_guesses. maybe something like adding or subtracting arrays
        @guess -= 1
        break if @guess.zero?
        break if @game_running == false
        # break if guesses is out or game is over
      end
    when 2
      # Saved Game
      pass
    end
  end
end

hang = Hangman.new
