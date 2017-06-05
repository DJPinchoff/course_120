class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

keybank = BankAccount.new(100)
puts keybank.positive_balance?

# Ben is correct. He's not missing an @ before the balance instance variable in the #positive_balance method. He doesn't need it because the attr_reader makes the balance variable accessible without the @ because it is calling its getter method.
