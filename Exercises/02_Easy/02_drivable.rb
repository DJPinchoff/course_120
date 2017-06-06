module Drivable
  def drive
  end
end

class Car
  include Drivable
end

bobs_car = Car.new
bobs_car.drive

#changed Line 2 by removing self.drive and replacing it with drive
