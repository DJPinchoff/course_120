class Person
  def name=(first_last)
    name_array = first_last.split
    @first_name = name_array[0]
    @last_name = name_array[1]
  end

  def name
    "#{first_name} #{last_name}"
  end

  private
  attr_accessor :first_name, :last_name
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name
