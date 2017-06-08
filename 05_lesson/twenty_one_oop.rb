module DisplayMessages
  MATCH_POINTS = 5
  def display_welcome_message
    clear_screen
    puts "Welcome to TWENTY-ONE"
    puts "Win #{MATCH_POINTS} rounds to win the match!"
  end

  def display_initial_computer_cards
    comp_card = computer.hand[1]
    puts "#{computer} shows: (#{comp_card.value}) #{comp_card}"
  end

  def display_initial_human_cards
    puts "#{human}'s cards: #{human.hand[0]} and #{human.hand[1]}"
    puts "#{human}'s total: #{human.total}"
  end

  def display_dealer_cards
    name = computer.name
    puts "#{name} reveals: #{computer.hand[0]} and #{computer.hand[1]}"
    puts "#{name}'s total: #{computer.total}"
  end

  def display_new_player_card
    puts "#{human}'s new card: #{human.hand[-1]}"
    return if busted?(human)
    puts "#{human}'s new total: #{human.total}"
  end

  def display_new_dealer_card
    puts "#{computer}'s new card: #{computer.hand[-1]}"
    puts "#{computer}'s new total: #{computer.total}"
  end

  def display_totals
    puts "#{human}'s total: #{human.total}"
    puts "#{computer}'s total: #{computer.total}"
  end

  def display_busted_message
    if busted?(computer)
      puts "#{computer} busted. #{human.name.upcase} WON!!"
    else
      puts "#{human} busted. #{computer.name.upcase} WON!!"
    end
  end

  def display_winner_or_tie
    if detect_winner
      puts "#{detect_winner.name.upcase} WON!!"
    else
      puts "It's a push. Nobody won!"
    end
  end

  def display_wins
    puts "#{human}'s wins: #{human.wins}"
    puts "#{computer}'s wins: #{computer.wins}"
  end

  def display_match_won
    if match_won?(human)
      puts "CONGRATULATIONS!! #{human} won the match."
    elsif match_won?(computer)
      puts "BETTER LUCK NEXT TIME!! #{computer} won the match."
    end
  end

  def display_goodbye_message
    clear_screen
    puts "Thank you for playing TWENTY-ONE!"
  end
end

class Participant
  attr_reader :hand, :wins

  def initialize
    reset_hand
    reset_wins
  end

  def get_card(card)
    @hand.push(card)
  end

  def busted?
    total > 21
  end

  def total
    sum = 0
    num_of_aces = 0
    hand.each do |card|
      if card.value == 1
        num_of_aces += 1
      else
        sum += card.value
      end
    end

    return sum if num_of_aces == 0
    sum += num_of_aces
    return sum += 10 if sum + 10 <= 21
    sum
  end

  def reset_hand
    @hand = []
  end

  def reset_wins
    @wins = 0
  end

  def increment_wins
    @wins += 1
  end

  def to_s
    name
  end
end

class Player < Participant
  attr_reader :name

  def initialize
    @name = set_name
    super
  end

  def set_name
    name = ""
    loop do
      print "What's your name? "
      name = gets.chomp.strip.capitalize
      break if name.length >= 2
      puts "Sorry, your name needs to be longer than just one letter."
    end

    name
  end

  def chooses_hit?
    choice = ""
    loop do
      puts "What would you like to do, #{name}?"
      print "(H)it or (S)tay >> "
      choice = gets.chomp.downcase
      break if %w[h s].include? choice
      puts "Sorry, you have to type an H or S."
      puts
    end

    choice == "h"
  end
end

class Dealer < Participant
  attr_reader :name

  def initialize(name)
    @name = name
    super()
  end

  def chooses_hit?
    total < 17
  end
end

class Deck
  attr_accessor :cards_in_deck, :cards_in_play

  def initialize
    @cards_in_play = []
    @cards_in_deck = []
    push_cards_into_deck
  end

  def push_cards_into_deck
    (1..52).each do |num|
      @cards_in_deck.push(Card.new(num))
    end
  end

  def deal
    card = nil
    loop do
      index = rand(0..51)
      if cards_in_deck[index]
        card = cards_in_deck[index]
        cards_in_deck[index] = nil
        cards_in_play[index] = card
        break
      end
    end

    card
  end

  def reset
    used_cards = cards_in_play.reject do |card|
      card.nil?
    end

    used_cards.each do |card|
      cards_in_deck[card.deck_index] = card
    end

    self.cards_in_play = []
  end
end

class Card
  SUITS = { (1..13) => 'Clubs',
            (14..26) => 'Diamonds',
            (27..39) => 'Spades',
            (40..52) => 'Hearts' }
  RANKS = { 1 => 'Ace', 2 => 'Two', 3 => 'Three',
            4 => 'Four', 5 => 'Five', 6 => 'Six',
            7 => 'Seven', 8 => 'Eight', 9 => 'Nine',
            10 => 'Ten', 11 => 'Jack', 12 => 'Queen',
            0 => 'King' } # key = (card_index % 13)

  attr_reader :rank, :value, :suit, :deck_index

  def initialize(card_index)
    SUITS.each do |range, suit|
      if range.include?(card_index)
        @deck_index = card_index - 1
        @suit = suit
        @rank = RANKS[card_index % 13]
        @value = card_index % 13
        @value = 10 if @value >= 10 || @value == 0
      end
    end
  end

  def to_s
    "#{@rank} of #{@suit}"
  end
end

class Game
  include DisplayMessages

  MATCH_POINTS = DisplayMessages::MATCH_POINTS
  COMPUTER_NAMES = ["R2D2", "Number 5", "Hal", "Sonny"]

  attr_accessor :human, :computer, :deck

  def initialize
    @deck = Deck.new
    @computer = Dealer.new(COMPUTER_NAMES.sample)
    @human = Player.new
  end

  def start
    loop do
      display_welcome_message
      display_blank_line
      deal_initial_cards
      display_initial_cards
      player_turn
      dealer_turn unless busted?(human)
      increment_winner
      display_blank_line
      display_results
      play_again? ? reset_settings : break
    end

    display_goodbye_message
  end

  private

  def display_blank_line
    puts
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def delay_effect
    3.times do
      print "."
      sleep(0.6)
    end
    puts
  end

  def deal_initial_cards
    2.times do
      human.get_card(deck.deal)
      computer.get_card(deck.deal)
    end
  end

  def display_initial_cards
    display_initial_computer_cards
    display_blank_line
    display_initial_human_cards
  end

  def player_turn
    while human.chooses_hit?
      display_blank_line
      human.get_card(deck.deal)
      display_new_player_card
      break if busted?(human)
    end
  end

  def dealer_turn
    display_blank_line
    display_dealer_cards

    while computer.chooses_hit?
      delay_effect
      computer.get_card(deck.deal)
      display_new_dealer_card
      break if busted?(computer)
    end
  end

  def busted?(participant)
    participant.busted?
  end

  def winner_when_busted
    return computer if busted?(human)
    return human if busted?(computer)
  end

  def increment_winner
    if detect_winner == human
      human.increment_wins
    elsif detect_winner == computer
      computer.increment_wins
    end
  end

  def display_results
    display_totals
    display_winning_message
    delay_effect
    display_wins
    display_match_won
  end

  def detect_winner
    return nil if tie?
    return winner_when_busted if busted?(human) || busted?(computer)
    return computer if computer.total > human.total
    human
  end

  def tie?
    computer.total == human.total
  end

  def display_winning_message
    if busted?(computer) || busted?(human)
      display_busted_message
    else
      display_winner_or_tie
    end
  end

  def match_won?(participant)
    participant.wins == MATCH_POINTS
  end

  def play_again?
    choice = ""
    loop do
      print "Would you like to play again? (Y/N) >> "
      choice = gets.chomp.downcase
      break if %w[y n].include? choice
      puts "Sorry, you have to type a Y or N."
    end

    choice == "y"
  end

  def reset_settings
    deck.reset
    reset_hands
    reset_wins if match_won?(human) || match_won?(computer)
  end

  def reset_hands
    human.reset_hand
    computer.reset_hand
  end

  def reset_wins
    human.reset_wins
    computer.reset_wins
  end
end

Game.new.start
