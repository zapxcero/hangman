# frozen_string_literal: true

# Plays a game of Hangman
class Hangman
  def initialize
    @guess = 10
    @game_running = true
    @dict = load_dict
    @secret_word = select_secret_word
    @user_guesses = []
    game
  end

  def load_dict
    File.open('dictionary.txt').readlines
  end

  def select_secret_word
    random_word = @dict.sample.chomp
    if random_word.length >= 5 && random_word.length <= 12
      random_word
    else
      select_secret_word
    end
  end

  def hint_secret_word
    puts "\nHere's the secret word's length and the guesses you've made."
    puts "\nGuesses: #{@user_guesses.join(', ')}\n\n"
    puts "\nWord: \n\n"
    @secret_word.chars.each do |letter|
      if @user_guesses.include? letter
        print "#{letter} "
      else
        print '_ '
      end
    end
    print "\n"
  end

  def user_guess_letter
    print "\n\nEnter a letter to (#{@guess}) guess the secret word: "
    letter = gets.chomp[0]
    if !(@user_guesses.include? letter)
      @user_guesses.push(letter)
      
    else
      clear_terminal
      hint_secret_word
      puts "\nYou have already entered that letter before!\n"
      user_guess_letter
    end
  end

  def winner?
    if @secret_word.chars.uniq.length == @user_guesses.length
      if (@user_guesses - @secret_word.chars).empty?
        puts "\nYou've guessed it! The word is #{@secret_word}.\n\n"
        @game_running = false
      end
    end
  end

  def clear_terminal
    system 'clear'
  end

  def main_menu
    puts "Do you want to:\n\n[1]Start a new game\n[2]Resume a saved game?\n\n"
    print 'Enter choice: '
    gets.chomp.to_i
  end

  def round
    loop do
      clear_terminal
      hint_secret_word
      user_guess_letter
      clear_terminal
      winner?
      @guess -= 1
      break if @guess.zero? || @game_running == false
    end
  end

  def game
    case main_menu
    when 1
      round
    when 2
      clear_terminal
      puts 'Saved Game!'
    end
  end
end

# TODO: add saved game functionality
Hangman.new
