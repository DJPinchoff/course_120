class InvoiceEntry
  attr_reader :product_name
  attr_accessor :quantity

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
    # self.quantity = updated_count if updated_count >= 0
  end
end

cart = InvoiceEntry.new("ball", 1)
puts cart.quantity
cart.update_quantity(2)
puts cart.quantity

# In the code above, quantity in the #update_quantity method was a local variable intitialized and unused after the method runs that line of code. To access the instance variable @quantity, you could simply change attr_reader to attr_accessor for the quantity variable to create a self.quantity setter method.  OR just prepend quantity with @ to access the instance variable directly.

# Question 3 : It's better to prepend quantity with @ otherwise if you add an attr_accessor, then the instance variable is accessible to be changed outside of the class which can be dangerous as the code grows.
