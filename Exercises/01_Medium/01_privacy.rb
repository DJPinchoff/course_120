# Consider the following class:
#
# Modify this class so both flip_switch and the setter method switch= are private methods.

class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def get_switch_state
    switch
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

p switch = Machine.new
p switch.start
p switch.get_switch_state
p switch.stop
p switch.get_switch_state
p switch.start
p switch.get_switch_state
