class SecretFile
  def initialize(secret_data)
    @data = secret_data
    @log = SecurityLogger.new
  end

  def data(entry)
    @log.create_log_entry(entry)
    @data
  end

  def log
    @log
  end
end

class SecurityLogger
  def initialize
    @entries = []
    @count = 0
  end

  def entries
    @entries
  end

  def create_log_entry(entry)
    @count += 1
    @entries << entry
  end
end

file = SecretFile.new("This is the secret!")
p file.log.entries
puts file.data("Hello")
p file.log.entries
puts file.data("Goodbye")
p file.log.entries
