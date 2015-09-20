require "flame/version"
require "flame/heating_circuit"
require "flame/heating_circuit/radiator"

module Flame
  attr_reader :status

  @status = false
  args = {target: {outdoor_temperature: 20, flow_temperature: 20},
       actual: {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: false},
       pump: false}

  @radiator = Radiator.new(args)

  def boot
    if @status
      "Heating system runs already."
    else
      @status = true
      "Heating system started at #{Time.now}"
      worker
    end
  end

  def worker
    while(@status)
      @radiator.business_logic
      sleep(3)
    end
  end

  def shutdown
    @status = false
    @radiator.shutdown
    "Heating system shuts down."
  end

  def running?
    @status
  end

end



end
