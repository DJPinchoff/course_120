class SecretFile
  def initialize(secret_data)
    @data = secret_data
    @log = SecurityLogger.new
  end

  def data
    @log.create_log_entry
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

  def create_log_entry
    @count += 1
    @entries << @count
  end
end

file = SecretFile.new("This is the secret!")
p file.log.entries
puts file.data
p file.log.entries
puts file.data
p file.log.entries
