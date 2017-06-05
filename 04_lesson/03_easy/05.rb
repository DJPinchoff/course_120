class Television
  def self.manufacturer
    puts "Manufacturer"
  end

  def model
    puts "Model"
  end
end

tv = Television.new
# tv.manufacturer # This is a class method and unavailable to the tv instance.
tv.model

Television.manufacturer
Television.model # undefined method 'model' for Television:Class because #model is an instance method
