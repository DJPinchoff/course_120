class BeesWax
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{type} type of Bees Wax."
  end
end

honey = BeesWax.new("honey")
honey.describe_type
