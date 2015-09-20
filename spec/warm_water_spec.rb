require 'spec_helper'

describe WarmWater do
  before(:each) do
    args =
      {target: {outdoor_temperature: 20, flow_temperature: 20},
       actual: {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: false},
       pump: true}
      @warmwater = WarmWater.new(args)
  end
  
  describe "#disable_district_heating?" do
    context "when pump is enabled" do

      it "given that pump is enabled" do
        @warmwater.enable(:pump)
        expect(@warmwater.status(:pump)).to be true
      end

      context "and boiler temperature is greater than (42+hysteresis value) " do
        it "disables district heating and pump" do
          @warmwater.disable(:district_heating)
          @warmwater.disable(:pump)	  
   	  expect(@warmwater.status(:district_heating)).to be false
   	  expect(@warmwater.status(:pump)).to be false
	end
      end

      context "and boiler temperature is less than (42+hysteresis value)" do

        context "when difference is greater than 5" do
          it "enables pump" do
	    @warmwater.enable(:pump)
	    expect(@warmwater.status(:pump)).to be true
	  end
        end

        context "when difference is less than 5" do
          it "enables district heating" do
	    @warmwater.enable(:district_heating)
	    expect(@warmwater.status(:district_heating)).to be true
	  end
        end
      end
    end
  end

  describe "#enable_district_heating?" do  
    before(:each) do
      args =
        {target: {outdoor_temperature: 20, flow_temperature: 20},
         actual: {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: false},
         pump: false}
        @warmwater = WarmWater.new(args)
    end

    context "when pump is disabled" do
      it {expect(@warmwater.status(:pump)).to be false}

      context "when central boiler temperature is less than 42" do
        it "measures difference between central boiler and storage boiler" do
          expect(@warmwater.difference).to be_a(Numeric)
	end

        context "when difference is greater than 5" do
          it "enables pump" do
	    @warmwater.enable(:pump)
	    expect(@warmwater.status(:pump)).to be true
	  end
        end

        context "when difference is less than 5" do
          it "enables district heating" do
	    @warmwater.enable(:district_heating)
	    expect(@warmwater.status(:district_heating)).to be true
	  end
        end	

      end

    end
  end

end

