class Player
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  attr_accessor :move, :name, :score, :history

  def initialize
    set_name
    @score = 0
    @history = []
  end

  def adjust_history(status)
    history.push(won: move) if status == :won
    history.push(lost: move) if status == :lost
    history.push(tie: move) if status == :tie
  end

  def increment_score
    self.score += 1
  end

  private

  def choose(choice)
    self.move = choice
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp.strip
      break unless n.empty? || n.length < 2
      puts "Sorry, must enter a name of two or more letters."
    end
    self.name = n
  end

  def prompt_input
    choice = ""
    loop do
      print "Choose (R)ock, (P)aper, (S)cissors, (Sp)ock, or (L)izard >> "
      choice = gets.chomp.downcase
      break if %w[r p s sp l].include? choice
      puts "Sorry, that wasn't a valid choice."
    end

    convert_letter = { "r" => "rock", "p" => "paper", "s" => "scissors",
                       "sp" => "spock", "l" => "lizard" }
    convert_letter[choice]
  end

  def choose
    choice = prompt_input
    super(choice)
  end
end

class Computer < Player
  VALUE_ARRAY_TIMES = 4

  def set_name
    self.name = self.class.to_s
  end
end

module ValueArray
  def value_array
    new_array = []
    Player::VALUES.each do |value|
      rule_modifier(value).times { new_array.push(value) }
    end

    new_array # Can p this out to verify creation of modified sample array
  end

  def choose
    choice = value_array.sample
    super(choice)
  end
end

class R2D2 < Computer # Only chooses rock
  def choose
    super('rock')
  end
end

class Number5 < Computer # Random choice for move
  def set_name
    self.name = "Number 5"
  end

  def choose
    choice = Player::VALUES.sample
    super(choice)
  end
end

class Hal < Computer
  # Prefers 'scissors', rarely 'rock', never 'paper'
  # Average 'spock' and 'lizard'
  include ValueArray

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
end

class Sonny < Computer
  # Makes strategic decisions based on history and rules
  include ValueArray

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
    puts "#{human.name} chose: #{human.move.capitalize}"
    puts "#{computer.name} chose: #{computer.move.capitalize}"
  end

  def display_scores
    puts "#{human.name}'s Score: #{human.score}"
    puts "#{computer.name}'s Score: #{computer.score}"
  end

  def display_results(winning_player)
    case winning_player
    when :human
      print "#{human.name} wins! "
    when :computer
      print "#{computer.name} wins! "
    when :tie
      print "It's a tie!"
    end
    puts sentence_constructor(winning_player)
    display_scores
  end

  def sentence_constructor(winning_player)
    hum_str = human.move
    comp_str = computer.move
    first = winning_player == :human ? hum_str.capitalize : comp_str.capitalize
    second = if winning_player == :human
               PHRASES[hum_str][comp_str]
             else
               PHRASES[comp_str][hum_str]
             end
    third = winning_player == :human ? comp_str : hum_str
    return " " if winning_player == :tie

    third = "Spock" if third == "spock"
    "#{first} #{second} #{third}!"
  end

  def display_histories
    puts "Human History: #{human.history}"
    puts "Computer History: #{computer.history}"
  end

  def adjust_history(winning_player)
    case winning_player
    when :human
      human.adjust_history(:won)
      computer.adjust_history(:lost)
    when :computer
      human.adjust_history(:lost)
      computer.adjust_history(:won)
    when :tie
      human.adjust_history(:tie)
      computer.adjust_history(:tie)
    end
  end

  def increment_score(winning_player)
    human.increment_score if winning_player == :human
    computer.increment_score if winning_player == :computer
  end

  def determine_winner
    player_choice = human.move
    computer_choice = computer.move
    if PHRASES[player_choice].key?(computer_choice)
      :human
    elsif PHRASES[computer_choice].key?(player_choice)
      :computer
    else
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

  def play
    print_hello
    loop do
      make_choices
      puts
      display_moves
      winner = determine_winner
      adjust_history(winner)
      increment_score(winner)
      display_results(winner)
      # display_histories
      puts
      game_over if end_of_match?
      break unless play_again?
    end
    print_goodbye
  end
end

RPSGame.new.play
