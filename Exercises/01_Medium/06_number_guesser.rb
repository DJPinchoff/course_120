class GuessingGame
  attr_reader :answer

  def initialize
    @turns_left = 7
  end

  def decrement_turns_left
    @turns_left -= 1
  end

  def reset_turns_left
    @turns_left = 7
  end

  def display_turns_left
    puts "You have #{@turns_left} guesses remaining."
  end

  def set_random_answer
    @answer = rand(0..100)
  end

  def get_player_guess
    guess = 0
    loop do
      print "Enter a number between 1 and 100: "
      guess = gets.chomp.to_i
      break if guess >= 0 && guess <= 100
      print "Invalid guess. "
    end

    guess
  end

  def display_feedback(guess)
    puts "Your guess is too high." if too_high?(guess)
    puts "Your guess it too low." if too_low?(guess)
    puts "You win!" if winner?(guess)
  end

  def too_high?(guess)
    guess > @answer
  end

  def too_low?(guess)
    guess < @answer
  end

  def winner?(guess)
    guess == @answer
  end

  def loser?
    @turns_left == 0
  end

  def display_losing_message
    puts "You are out of guesses. You lose."
  end

  def play
    reset_turns_left
    set_random_answer
    loop do
      puts
      display_turns_left
      guess = get_player_guess
      display_feedback(guess)
      break if winner?(guess)
      decrement_turns_left
      if loser?
        display_losing_message
        break
      end
    end
  end
end


game = GuessingGame.new
game.play
game.play
# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low
#
# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low
#
# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high
#
# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80
#
# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# You win!
#
# game.play
#
# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high
#
# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low
#
# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high
#
# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low
#
# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high
#
# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low
#
# You have 1 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low
# You are out of guesses. You lose.
