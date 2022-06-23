# frozen_string_literal: true

# All terminal display
module Display
  def clear_terminal
    system 'clear'
  end

  def display_hint
    <<~DISPLAY_HINT
      Here's the secret word's length (#{secret_word.length}) and the guesses you've made.

      Guesses: #{guesses_to_s}


      Word:#{all_guesses}


    DISPLAY_HINT
  end

  def display_menu
    <<~MENU
      Do you want to:
      [1]Start a new game
      [2]Resume a saved game?


      Enter choice:#{' '}
    MENU
  end

  def display_input
    <<~INPUT
      Enter a letter to (#{tries}) guess the secret word or type '0' to save the game:
    INPUT
  end

  def display_dupli
    <<~LETTER_DUP

      You have already entered that letter before!

    LETTER_DUP
  end

  def display_winner
    <<~WINNER

      You've guessed it! The word is #{secret_word}.


    WINNER
  end
end
