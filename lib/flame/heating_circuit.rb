require './flame/devices'
require './flame/configuration_interface'
require './flame/logging'
require 'active_record'
require 'json'

ActiveRecord::Base.establish_connection(
      adapter:    'postgresql',
      host:       'localhost',
      database:   'flame',
      username:   'postgres',
      password:   'Welcome2',
      port:       5432)

class HeatingCircuit < ActiveRecord::Base
  # EXTENSIONS
  include Logging
  extend ConfigurationInterface

  # ATTRIBUTES
  attr_reader :target, :actual, :heating_curve_temperature, :lead_temperature, :central_boiler_temperature, :storage_boiler_temperature, :mode
  TEMPERATURE_MEASURES = %w(lead_temperature heating_curve_temperature central_boiler_temperature storage_boiler_temperature)
  AVAILABLE_DEVICES = %i(mixer pump district_heating)

  def initialize(params={})
    super(params)
    simulate_temperatures
    build_credentials
    build_heating_tools
    build_temperature_program
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
    set_status(args, :enable)
  end

  def disable(*args)
    set_status(args, :disable)
  end

  def shutdown
    disable(:pump, :mixer, :district_heating)
  end

  def log
    Log.process(values)
  end

  def update
    ConfigurationInterface.update(self).each_pair do |name, value|
      @mode = value if name == :mode
      @target = {flow_temperature: value, outdoor_temperature: 20} if name == :flow_temperature
    end
  end

  private

    def possible_oscillation?
      false#Log.mixer_series.last_records(5)
    end

    def set_status(args, value)
      AVAILABLE_DEVICES.each { |device| set_status_code(device, value) if args.include?(device) }
    end

    def simulate_temperatures
      @actual = {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: false}
    end

    def build_credentials
      self.name = self.class.name
      self.id = HeatingCircuit.find_by_name(name).id
      self.sensor = HeatingCircuit.find(id).sensor
    end

    def build_heating_tools
      @mixer = Mixer.new
      @pump = Pump.new
      @district_heating = DistrictHeating.new
    end

    def build_temperature_program
      update.each_pair do |name, value|
        @mode = value if name == :mode
        @target = {flow_temperature: value, outdoor_temperature: 20} if name == :flow_temperature
      end
    end

    def turn_off?
      puts "Turn off condition: #{default_conditions(@actual, @target)}"
      default_conditions(@actual, @target)
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
    
    def period
      (last_timestamp-first_timestamp)/60
    end
  
    def last_timestamp
      self.maximum(:measured)
    end

    def first_timestamp
      self.minimum(:measured)
    end

    def mixer_series
      self.where(heating_circuit_id: id, mixer: true)
    end

    def last_records(n)
      self.last(n).reverse
    end

    def values
      basics = Hash[measured: Time.now, heating_circuit_id: self.id, mode: mode.to_s]
      temperatures = Hash[TEMPERATURE_MEASURES.map {|measure| [measure.to_sym, self.instance_variable_get("@#{measure}")]}]
      actuals = Hash[outdoor_temperature: actual[:outdoor_temperature], flow_temperature: actual[:flow_temperature]]
      heating_tools = Hash[mixer: @mixer.status, pump: @pump.status, district_heating: @district_heating.status]

      return basics.merge(temperatures).merge(actuals).merge(heating_tools)
    end

    def set_status_code(device, value)
      @pump.send(value) if device == :pump
      @mixer.send(value) if device == :mixer
      @district_heating.send(value) if device == :district_heating
    end
end

