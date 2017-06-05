class Animal
  attr_reader :color

  def initialize(color)
    @color = color
  end
end

class Cat < Animal
end
class Bird < Animal
end

cat1 = Cat.new('Black')
cat1.color
p cat1.class.ancestors

# #color is being called on the cat1 local variable which is pointing to a instantiated Cat object. The cat object has no methods of its own. So then, the method goes to its superclass Animal in which a getter method automatically created from the attr_reader :color is accessible returning the value of the instance variable @color. [Cat, Animal, Object, Kernel, BasicObject] is the array returned on cat1.class.ancestors.
