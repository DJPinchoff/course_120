class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# Instance variable is the Pizza class with the @name which indicates it is an instance variable.  The 'name' variable in the initialize method in the Fruit class is a local variable that disappears after the initialize method is run.
