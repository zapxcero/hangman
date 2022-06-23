# frozen_string_literal: true

require 'yaml'
require_relative 'display'
require_relative 'save_load'
# Hangman Game
class Hangman
  include Load
  include Display
  attr_accessor :tries, :game_running, :dict, :secret_word, :guesses_list

  def initialize
    @tries = 10
    @game_running = true
    @dict = dict_filter
    @secret_word = dict_sample
    @guesses_list = []

    puts secret_word
  end

  private

  # DICTIONARY
  def dict_load
    File.open('dictionary.txt').readlines
  end

  def word_length?(word)
    word.length >= 5 && word.length <= 12
  end

  def dict_filter
    dict_load.collect { |word| word if word_length?(word) }
  end

  def dict_sample
    dict.sample.chomp
  end

  # GUESSES
  def guesses_to_s
    guesses_list.join(', ')
  end

  def all_guesses
    secret_word.chars.collect { |letter| guesses_list.include?(letter) ? letter.to_s : '_ ' }.join('')
  end

  def input_guess
    puts display_input
    letter = input_choice
    if letter == '0'
      save
    elsif !letter_guessed?(letter)
      guesses_list.push(letter)
    else
      letter_new
      input_guess
    end
  end

  # LETTER
  def letter_new
    clear_terminal
    puts display_hint
    puts display_dupli
  end

  def letter_guessed?(letter)
    guesses_list.include? letter
  end

  def input_choice
    gets.chomp.chr
  end

  # MENU

  def menu
    puts display_menu
    menu_choice
  end

  def menu_choice
    gets.chomp.to_i
  end

  # GAME

  def game_end
    self.game_running = false
  end

  def winner?
    return unless secret_word.chars.uniq.length <= guesses_list.length && (guesses_list - secret_word.chars).empty?

    puts display_winner
    game_end
  end

  def round
    loop do
      clear_terminal
      puts display_hint
      input_guess
      clear_terminal
      winner?
      self.tries -= 1
      break if tries.zero? || game_running == false
    end
    puts "\n\nYou lose! The secret word is #{secret_word}.\n\n\n" if tries.zero?
  end

  public

  def game_start
    case menu
    when 1
      round
    when 2
      clear_terminal
      run_load
    end
  end
end

# TODO: ALL NEED IS SOME FIXING
# TOOD: if only 1 guesses remain and you correctly answer, it still loses

Hangman.new.game_start
