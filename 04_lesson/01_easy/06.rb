class Cube
  attr_reader :volume

  def initialize(volume)
    @volume = volume
  end
end

# Add something to above class to access @volume

p Cube.new(10).volume
