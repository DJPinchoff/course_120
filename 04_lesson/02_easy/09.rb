class Game
  def play
    puts "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    puts "Bingo comes first!"
    super
  end
end

# If we were to add a #play method to the Bingo Class, it would overide the current #play method in the superclass Game. However, it could still be called using the reserved keyword #super.

game_of_bingo = Bingo.new
game_of_bingo.play # => Bingo comes first!
                   # => Start the game!
