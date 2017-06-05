class Bag
  attr_reader :color, :material
  def initialize(color, material)
    @color = color
    @material = material
  end

  def to_s
    "I'm a #{color} #{material} bag."
  end
end

lunch = Bag.new("brown", "paper")
p lunch.to_s
p lunch.inspect
