require 'spec_helper'

describe LivingRoom do
  before(:each) do
    args =
      {target: {outdoor_temperature: 20, flow_temperature: 20},
       actual: {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: false},
       pump: false}
      @floor = LivingRoom.new(args)
  end

  describe "#business_logic" do
    context "when turn_off conditions are not met" do

      it "enables pump" do
	@floor.enable(:pump)
	expect(@floor.status(:pump)).to be true
      end

      it "given difference is greater than 2" do
	@floor.disable(:mixer)
	expect(@floor.status(:mixer)).to be false
      end

      it "given difference is less than -2" do
	@floor.enable(:mixer)
	expect(@floor.status(:mixer)).to be true
      end
    end
  end

  describe "#overheating?" do
    temperatures = []
    temperatures.push(40)
    it {expect(temperatures).to eq([40])}

    context "when series has three 40 in a row" do
      series = [40,40,40]
      it {allow(@floor).to receive(:shutdown)}
    end

    context "when series has not three 40 in a row" do
      series = [40,30,40]
      series.clear
      it {expect(series).to be_empty}
      it {allow(@floor).to receive(:monitor).and_return(nil)}
    end

    context "when series has less than three numbers in a row" do
      series = [40,40]
      it {allow(@floor).to receive(:monitor).and_return(nil)}
    end

  end

end


