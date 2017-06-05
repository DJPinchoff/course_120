# The only difference between the two sets of classes below is when you compare Line 11 to Line 19. On Line 11, the instance method #show_template is accessing the getter method created by the attr_accessor and returning the value of @template. On Line 19, self.template also accesses the getter method created by the attr_accessor.  You need self.template when setting the variable, but not when reading it.

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end
