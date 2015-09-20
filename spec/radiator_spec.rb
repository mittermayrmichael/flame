require 'spec_helper'

describe Radiator do
  before(:each) do
    args =
      {target: {outdoor_temperature: 20, flow_temperature: 20},
       actual: {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: false},
       pump: false}
      @radiator = Radiator.new(args)
  end

  describe "#business_logic" do
    context "when turn_off conditions are not met" do
      
      it "enables pump" do
	@radiator.enable(:pump)
        expect(@radiator.status(:pump)).to be true
      end

      it "given that mixer runtime has expired" do
	@radiator.disable(:mixer)
	expect(@radiator.status(:mixer)).to be false
      end

      it "given difference is greater than 2" do
	@radiator.disable(:mixer)
	expect(@radiator.status(:mixer)).to be false
      end

      it "given difference is less than -2" do
	@radiator.enable(:mixer)
	expect(@radiator.status(:mixer)).to be true
      end

    end
  end
end
