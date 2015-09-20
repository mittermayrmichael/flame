class WarmWater < HeatingCircuit
  attr_reader :central_boiler_temperature, :storage_boiler_temperature
 
  def default_conditions(actual, target)
  end

  def business_logic
    if status(:pump)
      disable(:district_heating, :pump) if central_boiler_temperature > (42 + hysteresis)
    else
      compare_boiler_temperature if central_boiler_temperature < 42
    end
  end

  def compare_boiler_temperature
    enable(:district_heating) if difference < 5
    enable(:pump)
  end

  def central_boiler_temperature
    @central_boiler_temperature = Random.rand(100)
  end

  def storage_boiler_temperature
    @storage_boiler_temperature = Random.rand(100)
  end

  def difference
    central_boiler_temperature-storage_boiler_temperature
  end

  def hysteresis
    Random.rand(10)
  end

end

