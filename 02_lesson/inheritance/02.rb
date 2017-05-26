class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    "bark!"
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    "meow!"
  end
end

cat = Cat.new
dog = Dog.new

puts dog.speak
puts dog.run
puts dog.jump
puts dog.swim
puts dog.fetch

puts cat.speak
puts cat.jump
puts cat.run
