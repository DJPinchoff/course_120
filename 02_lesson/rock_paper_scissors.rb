class Rock
  def >(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end

  def <(other_move)
    other_move.class == Paper || other_move.class == Spock
  end

  def to_s
    'rock'
  end
end

class Paper
  def >(other_move)
    other_move.class == Rock || other_move.class == Spock
  end

  def <(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end

  def to_s
    'paper'
  end
end

class Scissors
  def >(other_move)
    other_move.class == Paper || other_move.class == Lizard
  end

  def <(other_move)
    other_move.class == Rock || other_move.class == Spock
  end

  def to_s
    'scissors'
  end
end

class Lizard
  def >(other_move)
    other_move.class == Spock || other_move.class == Paper
  end

  def <(other_move)
    other_move.class == Rock || other_move.class == Scissors
  end

  def to_s
    'lizard'
  end
end

class Spock
  def >(other_move)
    other_move.class == Scissors || other_move.class == Rock
  end

  def <(other_move)
    other_move.class == Paper || other_move.class == Lizard
  end

  def to_s
    'spock'
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  attr_reader :value

  def initialize(value)
    @value = case value
             when 'rock'
               Rock.new
             when 'paper'
               Paper.new
             when 'scissors'
               Scissors.new
             when 'lizard'
               Lizard.new
             when 'spock'
               Spock.new
             end
  end

  def >(other_move)
    value > other_move.value
  end

  def <(other_move)
    value < other_move.value
  end

  def to_s
    @value.to_s
  end
end

class Player
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = []
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      print "Please choose Rock, Paper, Scissors, Spock, or Lizard >> "
      choice = gets.chomp.downcase
      break if Move::VALUES.include? choice
      puts "Sorry, that wasn't a valid choice."
    end

    self.move = Move.new(choice)
  end
end

class Computer < Player
  VALUE_ARRAY_TIMES = 4
end

module ValueArray
  def value_array
    new_array = []
    Move::VALUES.each do |value|
      rule_modifier(value).times { new_array.push(value) }
    end

    new_array # Can p this out to verify creation of modified sample array
  end
end

class R2D2 < Computer # Only chooses rock
  def set_name
    self.name = self.class.to_s
  end

  def choose
    self.move = Move.new('rock')
  end
end

class Number5 < Computer # Random choice for move
  def set_name
    self.name = self.class.to_s
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Hal < Computer
  # Prefers 'scissors', rarely 'rock', never 'paper'
  # Average 'spock' and 'lizard'
  include ValueArray

  def set_name
    self.name = self.class.to_s
  end

  def rule_modifier(value)
    case value
    when 'rock'
      VALUE_ARRAY_TIMES / 2
    when 'paper'
      0
    when 'scissors'
      VALUE_ARRAY_TIMES * 2
    when 'lizard'
      VALUE_ARRAY_TIMES
    when 'spock'
      VALUE_ARRAY_TIMES
    end
  end

  def choose
    self.move = Move.new(value_array.sample)
  end
end

class Sonny < Computer # Makes strategic decisions based on history and rules
  include ValueArray
  def set_name
    self.name = self.class.to_s
  end

  def percent_win(value)
    wins = history.select do |e|
      e.key?(:won) && e.value?(value)
    end
    wins = wins.length
    total = history.select { |e| e.value?(value) }.length
    return 50 if total < 2 # Wait to calculate until a bigger sample size

    Integer((wins.to_f / total.to_f) * 100)
  end

  def rule_modifier(value) # Change likelihood of move based on win history
    percent = percent_win(value)
    if percent < 30
      VALUE_ARRAY_TIMES / 2
    elsif percent < 60
      VALUE_ARRAY_TIMES
    elsif percent >= 60
      VALUE_ARRAY_TIMES * 2
    end
  end

  def choose
    self.move = Move.new(value_array.sample)
  end
end

class RPSGame
  WIN_POINTS = 5 # Points to win a match
  PHRASES = { 'rock' => { 'lizard' => 'crushes',
                          'scissors' => 'crushes' },
              'paper' => { 'rock' => 'covers',
                           'spock' => 'disproves' },
              'scissors' => { 'paper' => 'cuts',
                              'lizard' => 'decapitates' },
              'lizard' => { 'spock' => 'poisons',
                            'paper' => 'eats' },
              'spock' => { 'rock' => 'vaporizes',
                           'scissors' => 'smashes' } }
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    name = ['R2D2', 'Hal', 'Sonny', 'Number 5'].sample
    @computer = case name
                when 'R2D2'
                  R2D2.new
                when 'Hal'
                  Hal.new
                when 'Sonny'
                  Sonny.new
                when 'Number 5'
                  Number5.new
                end
  end

  def display_welcome_message
    n = human.name
    puts "Welcome to the Rock, Paper, Scissors, Spock, or Lizard Game!"
    puts "It's nice to meet you, #{n}! I'm #{computer.name}."
    puts "Press ENTER to continue."
  end

  def display_goodbye_message
    puts "Thanks for playing the Rock, Paper, Scissors, Spock, or Lizard Game!"
  end

  def display_moves
    puts "#{human.name} chose: #{human.move.value.class}"
    puts "#{computer.name} chose: #{computer.move.value.class}"
  end

  def display_scores
    puts "#{human.name}'s Score: #{human.score}"
    puts "#{computer.name}'s Score: #{computer.score}"
  end

  def display_results(winner)
    case winner
    when :human
      print "#{human.name} wins! "
    when :computer
      print "#{computer.name} wins! "
    when :tie
      print "It's a tie!"
    end
    puts sentence_constructor(winner)
    display_scores
  end

  def sentence_constructor(winner)
    hum_str = move_string(human)
    comp_str = move_string(computer)
    first = winner == :human ? hum_str.capitalize : comp_str.capitalize
    second = if winner == :human
               PHRASES[hum_str][comp_str]
             else
               PHRASES[comp_str][hum_str]
             end
    third = winner == :human ? comp_str : hum_str
    return " " if winner == :tie

    third = "Spock" if third == "spock"
    "#{first} #{second} #{third}!"
  end

  def display_histories
    puts "Human History: #{human.history}"
    puts "Computer History: #{computer.history}"
  end

  def increment_score(player)
    human.score += 1 if player.class.ancestors.include? Human
    computer.score += 1 if player.class.ancestors.include? Computer
  end

  def move_string(player)
    player.move.value.to_s
  end

  def adjust_history_human
    human.history.push(won: move_string(human))
    computer.history.push(lost: move_string(computer))
  end

  def adjust_history_computer
    human.history.push(lost: move_string(human))
    computer.history.push(won: move_string(computer))
  end

  def adjust_history_tie
    human.history.push(tie: move_string(human))
    computer.history.push(tie: move_string(computer))
  end

  def winner
    player_choice = human.move
    computer_choice = computer.move
    if player_choice > computer_choice
      increment_score(human)
      adjust_history_human
      :human
    elsif player_choice < computer_choice
      increment_score(computer)
      adjust_history_computer
      :computer
    else
      adjust_history_tie
      :tie
    end
  end

  def play_again?
    answer = nil
    loop do
      print "Would you like to play again? (Y/N) >> "
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Sorry, your answer must be Y or N."
    end

    answer == 'y'
  end

  def end_of_match?
    human.score == WIN_POINTS || computer.score == WIN_POINTS
  end

  def game_over
    if human.score == 5
      puts "#{human.name} won #{WIN_POINTS} times! CONGRATULATIONS!!"
    else
      puts "#{computer.name} won #{WIN_POINTS} times. GAME OVER!"
    end
    human.score = 0
    computer.score = 0
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def print_hello
    clear_screen
    display_welcome_message
    gets
  end

  def print_goodbye
    clear_screen
    display_goodbye_message
  end

  def make_choices
    clear_screen
    human.choose
    computer.choose
  end

  def display_methods
    display_moves
    display_results(winner)
    # display_histories
  end

  def play
    print_hello
    loop do
      make_choices
      puts
      display_methods
      puts
      game_over if end_of_match?
      break unless play_again?
    end
    print_goodbye
  end
end

RPSGame.new.play
