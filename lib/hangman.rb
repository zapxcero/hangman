# frozen_string_literal: true

require 'json'

module BasicSerializable
  @@serializer = JSON

  def serialize
    obj = {}
    instance_variables.map do |var|
      next if var.to_s == '@dict'
      next if var.to_s == '@game_running'

      obj[var] = instance_variable_get(var)
    end

    @@serializer.dump obj
  end

  def unserialize(string)
    obj = @@serializer.parse(string)
    obj.each_key do |key|
      instance_variable_set(key, obj[key])
    end
  end
end

# Plays a game of Hangman
class Hangman
  include BasicSerializable
  def initialize(guess = 10, user_guesses = [], secret_word = '')
    @guess = guess
    @game_running = true
    @dict = load_dict
    @secret_word = if secret_word == ''
                     select_secret_word
                   else
                     secret_word
                   end
    puts @secret_word

    @user_guesses = user_guesses
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
    puts "\nHere's the secret word's length (#{@secret_word.length}) and the guesses you've made."
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

  def save
    @game_running = false
    saved = File.open('save_game.json', 'w')
    saved.puts serialize
  end

  def load
    file = File.open('save_game.json', 'r')
    contents = file.read
    obj = unserialize(contents)
    Hangman.new(obj['@guess'], obj['@user_guesses'], obj['@secret_word']).round
  end

  def user_guess_letter
    print "\n\nEnter a letter to (#{@guess}) guess the secret word or type '0' to save the game: "
    letter = gets.chomp[0]
    if letter == '0'
      save
    elsif !(@user_guesses.include? letter)

      @user_guesses.push(letter)

    else
      clear_terminal
      hint_secret_word
      puts "\nYou have already entered that letter before!\n"
      user_guess_letter
    end
  end

  def winner?
    if @secret_word.chars.uniq.length <= @user_guesses.length && (@user_guesses - @secret_word.chars).empty?
      puts "\nYou've guessed it! The word is #{@secret_word}.\n\n"
      @game_running = false
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
    puts "\n\nYou lose! The secret word is #{@secret_word}.\n\n\n" if @guess.zero?
  end

  def game
    case main_menu
    when 1
      round
    when 2
      clear_terminal
      load
    end
  end
end

# TODO: GENERATE UNIQ RANDOM FILENAME FOR SAVED GAMES. 
Hangman.new.game
