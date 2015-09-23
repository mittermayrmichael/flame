module ConfigurationInterface

  # ATTRIBUTES
  attr_reader :heating_circuit, :params

  class << self
  
    def update(heating_circuit)
      @heating_circuit = heating_circuit
      read
    end

    private

      def read
	data = JSON.parse(File.read(sensor))
        update_settings(data)
        
        rescue => e
          puts "#{e.class}: #{e.message} - #{e.backtrace.join("\n")}"	
	  default_mode
      end

      def sensor
        "./config/#{@heating_circuit.sensor}.json"
      end

      def default_mode
	puts "Switched to default mode: normal"
        Hash[mode: :normal, flow_temperature: 20]
      end

      def update_settings(params)
        @params = params

        flow_temperature = automatic if mode == :automatic
        flow_temperature = lowered_temperature if mode == :lowered
        flow_temperature = normal_temperature if mode == :normal
        
	Hash[mode: mode, flow_temperature: flow_temperature]
      end
      
      def mode
        available_modes.fetch(operating_mode)
      end

      def available_modes
        Hash["ZEIT" => :automatic, "ABGESENKT" => :lowered, "NORMAL" => :normal]
      end

      def operating_mode
        @params["betriebsart"]
      end

      def lowered_temperature
        @params["temperatur_abgesenkt"]
      end

      def normal_temperature
        @params["temperatur_normal"]
      end

      def automatic
        if nightshift.include?(time_threshold)
  	  lowered_temperature
        else
	  normal_temperature
        end
      end

      def plans
        @params["zeitprogramm"]["plans"]
      end

      def nightshift
        plans.first["start"] .. plans.second["start"]
      end

      def time_threshold
        "#{Time.now.hour}#{Time.now.min}"
      end

  end
end
