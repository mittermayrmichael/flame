class Device
  attr_reader :status

  def initialize
    @status = false
  end

  def enable
    @status = true
    puts "Enable: #{self.class}"
  end

  def disable
    @status = false
    puts "Disable: #{self.class}"
  end

end

class Mixer < Device
  attr_reader :turn_on_temperature, :turn_off_temperature
  
  def initialize(args)
    super()
    @turn_on_temperature = args[:turn_on_temperature] || -2
    @turn_off_temperature = args[:turn_off_temperature] || 2
  end

  def enable(target_runtime = 5)
    @status = true
    puts "Enable: #{self.class}"
  end

  def oscillate?
    
  end

end

class Pump < Device
end

class DistrictHeating < Device
end

