require "lib/flame/heating_circuit"

class Radiator < HeatingCircuit
  attr_reader :temperature_change, :mixer_condition

  def business_logic    
    unless turn_off?
      enable(:pump)
      enable(:mixer) if difference < @mixer.turn_on_temperature
      disable(:mixer) if (difference > @mixer.turn_off_temperature) || possible_oscillation?
    end
  end

end
