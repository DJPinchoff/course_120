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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
p drawn.count { |card| card.rank == 5 } == 4
p drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.
