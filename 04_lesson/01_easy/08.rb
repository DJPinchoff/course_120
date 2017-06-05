class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

kitty = Cat.new('Tabby')
p kitty.age
kitty.make_one_year_older
p kitty.age
kitty.make_one_year_older
p kitty.age
kitty.make_one_year_older
p kitty.age

# self on Line 10 refers to the instance kitty in this case. or whatever instance you have created since make_one_year_older is an instance method.
