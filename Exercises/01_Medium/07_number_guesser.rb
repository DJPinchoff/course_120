class GuessingGame
  attr_reader :answer, :high_value, :low_value

  def initialize(low_value, high_value)
    @low_value = low_value
    @high_value = high_value
  end

  def decrement_turns_left
    @turns_left -= 1
  end

  def set_turns_left
    @turns_left = Math.log2(high_value - low_value).to_i + 1
  end

  def display_turns_left
    puts "You have #{@turns_left} guesses remaining."
  end

  def set_random_answer
    @answer = rand(low_value..high_value)
  end

  def get_player_guess
    guess = 0
    loop do
      print "Enter a number between #{low_value} and #{high_value}: "
      guess = gets.chomp.to_i
      break if guess >= low_value && guess <= high_value
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
    puts "You are out of guesses. You lose. It was #{answer}."
  end

  def play
    set_turns_left
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


game = GuessingGame.new(501, 1500)
game.play
game.play
=begin
You have 10 guesses remaining.
Enter a number between 501 and 1500: 104
Invalid guess. Enter a number between 501 and 1500: 1000
Your guess is too low

You have 9 guesses remaining.
Enter a number between 501 and 1500: 1250
Your guess is too low

You have 8 guesses remaining.
Enter a number between 501 and 1500: 1375
Your guess is too high

You have 7 guesses remaining.
Enter a number between 501 and 1500: 80
Invalid guess. Enter a number between 501 and 1500: 1312
Your guess is too low

You have 6 guesses remaining.
Enter a number between 501 and 1500: 1343
Your guess is too low

You have 5 guesses remaining.
Enter a number between 501 and 1500: 1359
Your guess is too high

You have 4 guesses remaining.
Enter a number between 501 and 1500: 1351
Your guess is too high

You have 3 guesses remaining.
Enter a number between 501 and 1500: 1355
You win!

game.play
You have 10 guesses remaining.
Enter a number between 501 and 1500: 1000
Your guess is too high

You have 9 guesses remaining.
Enter a number between 501 and 1500: 750
Your guess is too low

You have 8 guesses remaining.
Enter a number between 501 and 1500: 875
Your guess is too high

You have 7 guesses remaining.
Enter a number between 501 and 1500: 812
Your guess is too low

You have 6 guesses remaining.
Enter a number between 501 and 1500: 843
Your guess is too high

You have 5 guesses remaining.
Enter a number between 501 and 1500: 820
Your guess is too low

You have 4 guesses remaining.
Enter a number between 501 and 1500: 830
Your guess is too low

You have 3 guesses remaining.
Enter a number between 501 and 1500: 835
Your guess is too low

You have 2 guesses remaining.
Enter a number between 501 and 1500: 836
Your guess is too low

You have 1 guesses remaining.
Enter a number between 501 and 1500: 837
Your guess is too low

You are out of guesses. You lose.
=end
