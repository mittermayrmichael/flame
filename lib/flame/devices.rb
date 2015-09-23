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
  
  def initialize
    super()
    @turn_on_temperature = -2#args[:turn_on_temperature] || -2
    @turn_off_temperature = 2#args[:turn_off_temperature] || 2
  end

end

class Pump < Device
end

class DistrictHeating < Device
end

