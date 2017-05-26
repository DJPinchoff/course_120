class Student
  attr_accessor :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def to_s
    "#{name} has a grade of #{grade}."
  end

  def better_grade_than?(other)
    grade > other.grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 95)
bob = Student.new("Bob", 90)
puts joe
puts bob
puts "Well done!" if joe.better_grade_than?(bob)
