class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green."
  end
end

# The attr_accessor is used to create getter and setter methods but it doesn't add any immediate value because they aren't called at all in the code in the other methods throughout the class.  They are exposed outside of the class with an instance.brightness call or instance.color call.  Also, the return on Line 10 is superfluous. (Much like the word superfluous.)
