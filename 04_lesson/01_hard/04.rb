module Wheeled
  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Vehicle
  attr_accessor :speed, :heading

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @speed = 0
    @heading = "N"
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class Auto < Vehicle
  include Wheeled
end

class Motorcycle < Vehicle
  include Wheeled
end

class WaterVehicle < Vehicle
  attr_accessor :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    self.propeller_count = num_propellers
    self.hull_count = num_hulls
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end

  def range
    super + 10
  end
end


class Catamaran < WaterVehicle
end

class Motorboat < WaterVehicle
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    super(1, 1, km_traveled_per_liter, liters_of_fuel_capacity)
  end
end

cat = Catamaran.new(2, 2, 10, 10)
car = Auto.new([5, 5, 5, 5], 10, 25)
bike = Motorcycle.new([5, 5], 20, 10)
boat = Motorboat.new(10, 10)

puts cat.range
puts car.range
puts bike.range
puts boat.range
puts
puts cat.propeller_count
puts cat.hull_count
puts
puts boat.propeller_count
puts boat.hull_count
puts car.tire_pressure(0)
p car.tire_pressure(1)
p car.tire_pressure(2)
p car.tire_pressure(3)

puts
car.inflate_tire(0, 10)
p car.tire_pressure(0)
puts
puts cat.speed
puts cat.heading
