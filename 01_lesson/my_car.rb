module Towable
  def Tow
    "#{self} Right now, it's towing."
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model
  @@number_of_vehicles = 0

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @speed = 0
    @@number_of_vehicles += 1
  end

  def print_holders(cup_holders)
    puts "Cup Holders: #{cup_holders} in #{self}"
  end

  def self.number_of_vehicles
  puts "There are #{@@number_of_vehicles} vehicles in the #{self} class."
  end

  def speed_up(number)
    @speed += number
    puts "You push the gas and accelerate #{number} mph."
  end

  def brake(number)
    @speed -= number
    puts "You push the brake and decelerate #{number} mph."
  end

  def speed
    puts "You are now going #{@current_speed} mph."
  end

  def turn_off
    @speed = 0
    puts "Turning off the car!"
  end

  def spray_paint(color)
    self.color = color
    puts "You've spray painted your car #{color}."
  end

  def gas_mileage(miles, gallons)
    puts "Your vehicle is getting #{miles / gallons} mpg."
  end

  def to_s
    "You are driving a #{color} #{year} #{model}. "
  end

  def age
    "Your vehicle is #{calculate_age(self.year)} years old."
  end

  private

  def calculate_age(year)
    Time.now.year - year 
  end
end

class MyCar < Vehicle
  CUP_HOLDERS = 4
  def print_holders
    super(CUP_HOLDERS)
  end
end

class MyTruck < Vehicle
  CUP_HOLDERS = 2
  include Towable

  def print_holders
    puts "There are #{CUP_HOLDERS} cup holders in #{self}."
  end
end

fit = MyCar.new(2015, "Honda Fit", "Black")
puts fit.color
fit.color = "Orange"
puts fit.color

puts fit.year

fit.spray_paint("Turquoise")
fit.gas_mileage(280, 7)
puts fit

ram = MyTruck.new(2017, "Ford F150", "Blue")
puts ram

Vehicle.number_of_vehicles
puts ram.Tow
puts MyCar.ancestors
puts MyTruck.ancestors
puts Vehicle.ancestors

ram.color = "Seafoam Green"
puts ram
ram.spray_paint("Burnt Orange")
puts ram.color
puts ram.model
puts ram.year
ram.print_holders
fit.print_holders
puts
puts fit.age
