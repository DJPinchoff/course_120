require 'pry'

class Card
  include Comparable

  RANK_TO_VALUE = { 'Jack' => 11, 'Queen' => 12,
                    'King' => 13, 'Ace' => 14 }

  attr_reader :rank, :suit, :value

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = set_value(rank)
  end

  def set_value(rank)
    if rank.to_s.to_i == rank
      @value = rank
    else
      @value = RANK_TO_VALUE[rank]
    end
  end

  def <=>(other)
    value <=> other.value
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = (2..10).to_a + %w(Jack Queen King Ace).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_accessor :cards

  def initialize
    reset
  end

  def reset
    @cards = []
    create_cards
  end

  def create_cards
    SUITS.each do |suit|
      RANKS.each do |rank|
        cards << Card.new(rank, suit)
      end
    end
  end

  def draw
    reset if cards.compact.empty?
    card = nil
    loop do
      index = rand(0..51)
      if cards[index]
        card = cards[index]
        cards[index] = nil
        break
      end
    end

    card
  end
end

class PokerHand
  attr_accessor :hand

  def initialize(deck)
    @hand = []
    create_hand(deck)
  end

  def create_hand(deck)
    5.times do
        hand << deck.draw
    end
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    sorted = hand.sort
    sorted[0].value == 10 && straight_flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    hand.each do |card1|
      return true if hand.count { |card| card == card1 } == 4
    end

    false
  end

  def full_house?
    hand.each do |card1|
      if hand.count { |card| card == card1 } == 3
        hand.each_with_index do |card2, index2|
          hand.each_with_index do |card3, index3|
            next if index3 <= index2
            return true if card2 == card3 && card2 != card1
          end
        end
      end
    end

    false
  end

  def flush?
    hand.all? { |card| card.suit == hand[0].suit }
  end

  def straight?
    sorted = hand.sort
    value = sorted[0].value
    one_above = 0
    (1..4).each do |index|
      one_above += 1 if sorted[index].value == value + 1
      value = sorted[index].value
    end

    one_above == 4
  end

  def three_of_a_kind?
    hand.each do |card1|
      return true if hand.count { |card| card == card1 } == 3
    end

    false
  end

  def two_pair?
    matches = 0
    hand.each_with_index do |card1, index1|
      hand.each_with_index do |card2, index2|
        next if index2 == index1
        matches += 1 if card1 == card2
      end
    end

    matches == 4
  end

  def pair?
    hand.each_with_index do |card1, index1|
      hand.each_with_index do |card2, index2|
        next if index2 <= index1
        return true if card1 == card2
      end
    end

    false
  end
end

puts
hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate  == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
