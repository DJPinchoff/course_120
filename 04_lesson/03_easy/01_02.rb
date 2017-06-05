class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def self.hi
    greeting = Greeting.new
    greeting.greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi # => #hi was not a class method and not available to Hello class but I prepended #hi with self which now makes it available (and added code to instantiate a Greeting object which could use the instance method #greet in the Greeting class.)
hello = Hello.new
# hello.hi # => "Hello"
# hello.bye # => No Method Error
# hello.greet => Invalid number of arguments Error
# hello.greet("Goodbye") # => "Goodbye"
