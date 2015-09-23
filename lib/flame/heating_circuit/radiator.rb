require "./flame/heating_circuit"

class Radiator < HeatingCircuit

  def business_logic    
    unless turn_off?
      enable(:pump)
      enable(:mixer) if difference < @mixer.turn_on_temperature
      disable(:mixer) if (difference > @mixer.turn_off_temperature) || possible_oscillation?
      log
    end
  end

end
