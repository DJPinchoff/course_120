module Flyable
  def fly
    "I'm flying!"
  end
end

class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end

class Bird < Animal
  include Flyable
end

bird1 = Bird.new('Red')
bird1.color
p bird1.class.ancestors
=begin
# Look up path for #color method:
  -Bird Class: no method found
  -Flyable Module: no method found
  -Animal Class: module found as getter from attr_reader: returns @color
  -NO MORE METHOD LOOKUPS SINCE IT HAS BEEN FOUND AND RETURNED
=end
