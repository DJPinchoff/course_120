class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

# Given the below usage of the Person class, code the class definition.

bob = Person.new('bob')
p bob.name                  # => 'bob'
bob.name = 'Robert'
p bob.name
