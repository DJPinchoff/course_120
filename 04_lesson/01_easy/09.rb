class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age = 0
    @@cats_count += 1
    puts "Cat initialized!"
  end

  def self.cats_count
    @@cats_count
  end
end
p Cat.cats_count
kitty = Cat.new("Tabby")
p Cat.cats_count
frank = Cat.new("Siamese")
p Cat.cats_count
