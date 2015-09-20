class Floor < HeatingCircuit
  attr_reader :temperatures

  def business_logic
    unless turn_off?
      enable(:pump)
      
      if overheating?
	puts "Overheating!"
	shutdown
      else     
	enable(:mixer) if difference < @mixer.turn_on_temperature
        disable(:mixer) if (difference > @mixer.turn_off_temperature) || @mixer.expired?
      end

    end
  end

  private

    def default_conditions(actual, target)
      (actual[:outdoor_temperature] > target[:outdoor_temperature]) || actual[:boiler_pump]
    end

    def overheating?
      @temperatures << @lead_temperature
      return true if alert?
      @temperatures.clear if series_complete?
    end

    def series(n)
      @temperatures.first(n)
    end

    def series_complete?
      series(3).size == 3
    end

    def alert?
      puts "Series: #{series(3)}"
      series(3).map {|temperature| temperature > 40 }.all? && series_complete?
    end

end

