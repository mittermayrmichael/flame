require "lib/flame/devices"

class HeatingCircuit
  attr_reader :target, :actual, :condition, :heating_curve_temperature, :lead_temperature, :temperatures

  AVAILABLE_DEVICES = [:mixer, :pump, :district_heating]
  
  def initialize(args)
    @target = args[:target]
    @actual = args[:actual]    
    @condition = default_conditions(actual, target)
    @mixer = Mixer.new(args)
    @pump = Pump.new
    @district_heating = DistrictHeating.new
  end
  
  def business_logic
  end

  def default_conditions(actual, target)
    (actual[:outdoor_temperature] > target[:outdoor_temperature]) || 
    (actual[:flow_temperature] > target[:flow_temperature]) ||
    actual[:boiler_pump]
  end

  def status(tool)
    return @pump.status if tool == :pump
    return @mixer.status if tool == :mixer
    return @district_heating.status if tool == :district_heating
  end

  def enable(*args)
    set_status(*args, :enable)
  end

  def disable(*args)
    set_status(*args, :disable)
  end

  def set_status(*args, value)
    AVAILABLE_DEVICES.each { |device| set_status_code(device, value) if args.include?(device) }
  end

  def set_status_code(device, value)
    @pump.send(value) if device == :pump
    @mixer.send(value) if device == :mixer
    @district_heating.send(value) if device == :district_heating
  end

  def shutdown
    disable(:pump, :mixer, :district_heating)
  end

  def possible_oscillation?
    false
  end

  private

    def turn_off?
      puts "Turn off condition: #{condition}"
      condition
    end

    def heating_curve
      Random.rand(60)
    end

    def difference
      puts "Difference: #{heating_curve_temperature-lead_temperature}"
      heating_curve_temperature-lead_temperature
    end

    def lead_temperature
      @lead_temperature = Random.rand(100)
    end

    def heating_curve_temperature
      @heating_curve_temperature = Random.rand(100)
    end

end
