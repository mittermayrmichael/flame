require "./flame/version"
require "./flame/heating_circuit"
require "./flame/heating_circuit/radiator"

module Flame
  attr_reader :status
  @status = false
  @radiator = Radiator.new

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
      update
      sleep(3)
    end
  end

  def update
    @radiator.update
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
