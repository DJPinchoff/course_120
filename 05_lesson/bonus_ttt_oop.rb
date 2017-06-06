class Array
  def joinor(delimiter = ', ', word = 'or')
    case size
    when 0 then ''
    when 1 then first
    when 2 then join(" #{word} ")
    else
      self[-1] = "#{word} #{last}"
      join(delimiter)
    end
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker # returns winning marker or nil
    WINNING_LINES.each do |line|
      squares_array = @squares.values_at(*line)
      if matching_markers?(squares_array)
        return squares_array.first.marker
      end
    end

    nil
  end

  def find_gap_in_line_of(marker)
    WINNING_LINES.each do |a, b, c|
      return a if matching_markers?(@squares.values_at(b, c), marker) &&
                  unmarked_keys.include?(a)
      return b if matching_markers?(@squares.values_at(a, c), marker) &&
                  unmarked_keys.include?(b)
      return c if matching_markers?(@squares.values_at(a, b), marker) &&
                  unmarked_keys.include?(c)
    end

    nil
  end

  def reset_squares_to(symbol)
    case symbol
    when :numbers
      (1..9).each { |key| @squares[key] = Square.new(key.to_s) }
    when :unmarked
      (1..9).each { |key| @squares[key] = Square.new }
    end
  end

  def draw
    puts "         |       |"
    puts "     #{@squares[1]}   |   #{@squares[2]}   |   #{@squares[3]}"
    puts "  _______|_______|_______"
    puts "         |       |"
    puts "     #{@squares[4]}   |   #{@squares[5]}   |   #{@squares[6]}"
    puts "  _______|_______|_______"
    puts "         |       |"
    puts "     #{@squares[7]}   |   #{@squares[8]}   |   #{@squares[9]}"
    puts "         |       |"
  end

  private

  def matching_markers?(squares, marker = nil)
    squares.all? do |sq|
      if marker
        sq.marked? && sq.marker == marker
      else
        sq.marked? && sq.marker == squares.first.marker
      end
    end
  end
end

class Square
  INITIAL_MARKER = " "
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    !unmarked?
  end
end

class Player
  attr_reader :score
  attr_accessor :name, :marker

  def initialize
    @score = 0
  end

  def increment_score
    @score += 1
  end

  def reset_score
    @score = 0
  end
end

class TTTGame
  X_MARKER = "X"
  O_MARKER = "O"
  MATCH_POINTS = 5
  attr_reader :board, :human, :computer
  attr_accessor :current_player, :initial_player

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
  end

  def play
    initial_display_and_settings

    loop do
      reset_current_player_to_initial_player
      display_initial_board

      loop do
        current_player_moves
        update_current_player
        break if board.someone_won? || board.full?

        display_board if human_turn?
      end

      update_and_display_results
      break unless play_again?
      reset_scores if match_won?
    end

    display_goodbye_message
  end

  private

  def initial_display_and_settings
    clear_screen
    display_welcome_message
    puts
    set_names
    display_greeting
    puts
    player_settings
  end

  def update_and_display_results
    increment_winner
    display_result
  end

  def player_chooses_first_player
    choice = ""
    loop do
      print "Do you want to go first? (Y/N) "
      choice = gets.chomp.downcase
      break if %w[y n].include? choice
      puts "You must pick Y or N."
    end

    self.initial_player = if choice == "y"
                            human.marker
                          else
                            computer.marker
                          end
  end

  def player_chooses_marker
    choice = ""
    loop do
      print "Do you want to play with X or O? "
      choice = gets.chomp.upcase
      break if %w[X O].include? choice
      puts "You must choose X or O."
    end

    human.marker = choice
    computer.marker = human.marker == X_MARKER ? O_MARKER : X_MARKER
  end

  def player_settings
    player_chooses_marker
    player_chooses_first_player
  end

  def display_greeting
    puts "Hi, #{human.name}! You can call me #{computer.name}."
    puts
  end

  def set_human_name
    name = ""
    loop do
      print "What's your name? "
      name = gets.chomp.strip
      break unless name.length < 2
      puts "You need to enter at least two letters for a name."
    end
    human.name = name
  end

  def set_computer_name
    computer.name = %w[Hal Sonny R2D2 Number_5].sample
  end

  def set_names
    set_human_name
    set_computer_name
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    clear_screen
    puts "  You're #{human.marker}. Computer is #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def display_initial_board
    board.reset_squares_to(:numbers)
    display_board
    board.reset_squares_to(:unmarked)
  end

  def reset_current_player_to_initial_player
    @current_player = initial_player
  end

  def human_turn?
    @current_player == human.marker
  end

  def human_moves
    puts "Choose a square!"
    square = nil
    loop do
      print "(#{board.unmarked_keys.joinor}): "
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_strategic_move
    move = board.find_gap_in_line_of(computer.marker) # offensive
    return move if move

    move = board.find_gap_in_line_of(human.marker) # defensive
    return move if move

    nil
  end

  def computer_moves
    if computer_strategic_move
      board[computer_strategic_move] = computer.marker
    elsif board.unmarked_keys.include?(5)
      board[5] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
    else
      computer_moves
    end
  end

  def update_current_player
    @current_player = if @current_player == human.marker
                        computer.marker
                      else
                        human.marker
                      end
  end

  def match_won?
    computer.score == MATCH_POINTS || human.score == MATCH_POINTS
  end

  def reset_scores
    human.reset_score
    computer.reset_score
  end

  def display_result
    display_board

    if match_won?
      display_match_result
    else
      case board.winning_marker
      when human.marker
        puts "#{human.name} won the round!"
      when computer.marker
        puts "#{computer.name} won the round!"
      else
        puts "This round is a tie!"
      end
    end

    display_score
  end

  def display_match_result
    if human.score == MATCH_POINTS
      puts "CONGRATULATIONS! #{human.name} won the match."
    else
      puts "BETTER LUCK NEXT TIME! #{computer.name} won the match."
    end
  end

  def increment_winner
    if board.winning_marker == human.marker
      human.increment_score
    elsif board.winning_marker == computer.marker
      computer.increment_score
    end
  end

  def display_score
    puts "#{human.name}'s Score: #{human.score}"
    puts "#{computer.name}'s Score: #{computer.score}"
  end

  def play_again?
    answer = ""
    loop do
      print "Would you like to play again? (Y/N): "
      answer = gets.chomp.downcase
      break if %w[y n].include? answer
      puts "You must pick Y or N."
    end

    answer == 'y'
  end

  def clear_screen
    system('clear') || system('cls')
  end
end

game = TTTGame.new
game.play
