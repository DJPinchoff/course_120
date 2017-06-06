

class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def walk
    puts "#{name} #{gait} forward"
  end

  private

  def gait
    "strolls"
  end
end

class Cat < Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah < Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"
