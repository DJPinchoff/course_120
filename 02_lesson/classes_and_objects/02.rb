# Modify the class definition from above to facilitate the following methods. Note that there is no name= setter method now.

class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    name_array = Array.new(2) { "" }
    name_array = name.split
    @first_name = name_array[0]
    @last_name = name_array[1]
  end

  def name
    "#{first_name} #{last_name}"
  end
end

bob = Person.new('Robert')
puts bob.name                  # => 'Robert'
puts bob.first_name            # => 'Robert'
puts bob.last_name             # => ''
bob.last_name = 'Smith'
puts bob.name                  # => 'Robert Smith'
# Hint: let first_name and last_name be "states" and create an instance method called name that uses those states.
