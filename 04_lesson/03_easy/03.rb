class AngryCat
  def initialize(age, name)
    @age = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hissss!!!"
  end
end

frank = AngryCat.new(10, "Frank")
kitty = AngryCat.new(5, "Kitty")

frank.name
frank.age
frank.hiss
puts
kitty.name
kitty.age
kitty.hiss
