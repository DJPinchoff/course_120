class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age = 0
    @@cats_count += 1
  end
  def self.cats_count
    @@cats_count
  end
end

#@@cats_Count is a class variable that can only be accessed by the class and not an instance. Every time an instance of the object is initialized, the @@cats_count variable is incremented thus keeping track of how many Cat objects exist.
