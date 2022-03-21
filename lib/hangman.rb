# frozen_string_literal: true

# Plays a game of Hangman
class Hangman
  def initialize
    @guess = 10
    @game_running = true
    @dict = load_dict
    @secret_word = select_secret_word
    p @secret_word
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
    @user_guesses.push(letter) unless @user_guesses.include? letter
  end

  def winner?
    pass
  end

  def main_menu
    puts "Do you want to:\n\n[1]Start a new game\n[2]Resume a saved game?\n\n"
    print 'Enter choice: '
    gets.chomp.to_i
  end

  def game
    case main_menu
    when 1
      loop do
        hint_secret_word
        user_guess_letter
        @guess -= 1
        break if @guess.zero? || @game_running == false
      end
    when 2
      puts "Saved Game!"
    end
  end
end

Hangman.new
