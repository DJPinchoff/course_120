require 'pry'

class MinilangRuntimeError < RuntimeError; end
class EmptyStackError < MinilangRuntimeError; end
class BadTokenError < MinilangRuntimeError; end

class Minilang
  COMMANDS = %w[push add sub mult div mod pop print]

  attr_accessor :register, :stack
  attr_reader :program

  def initialize(program)
    @register = 0
    @stack = []
    @program = program
  end

  def eval
    self.program.split.each { |command| eval_instruction(command.downcase)}
    rescue MinilangRuntimeError => error
      puts error.message
  end

  def eval_instruction(instruction)
    if COMMANDS.include?(instruction)
      send(instruction)
    elsif instruction.to_i.to_s == instruction
      self.register = instruction.to_i
    else
      raise BadTokenError, "Invalid token: #{instruction.upcase}"
    end
  end

  def push
    self.stack << self.register
  end

  def add
    self.register += self.stack.pop
  end

  def sub
    self.register -= self.stack.pop
  end

  def mult
    self.register *= self.stack.pop
  end

  def div
    self.register = self.register / self.stack.pop
  end

  def mod
    self.register = self.register % self.stack.pop
  end

  def pop
    if self.stack.empty?
      raise EmptyStackError, "Empty stack!"
    else
      self.register = self.stack.pop
    end
  end

  def print
    puts self.register
  end
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
