class CircularQueue
  attr_accessor :array

  def initialize(max_length)
    @array = Array.new(max_length)
  end

  def dequeue
    index = array.index { |item| !item.nil? }
    return index if index.nil?
    item = array[index]
    array[index] = nil
    item
  end

  def enqueue(item)
    move_queue_over if !array[-1].nil?
    array[-1] = item
  end

  def move_queue_over
    (0..array.length - 2).each do |idx|
      array[idx] = array[idx + 1]
    end

    array[-1] = nil
  end
end


queue = CircularQueue.new(3)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
