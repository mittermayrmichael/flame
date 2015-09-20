require 'spec_helper'

describe HeatingCircuit do

  describe "#business_logic" do
    xit {}
  end

  describe "#turn_off?" do
    context 'when conditions are met' do
      let(:target) {{:target => {outdoor_temperature: 20, flow_temperature: 20}}}
      let(:actual) {{:actual => {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: true}}}

      subject {HeatingCircuit.new(target.merge(actual))}
      it {expect(subject.send(:turn_off?)).to be true}
    end

    context 'when conditions are not met' do
      let(:target) {{:target => {outdoor_temperature: 20, flow_temperature: 20}}}
      let(:actual) {{:actual => {outdoor_temperature: 19, flow_temperature: 19, boiler_pump: false}}}

      subject {HeatingCircuit.new(target.merge(actual))}
      it {expect(subject.send(:turn_off?)).to be false}
    end
  end

  describe "#default_conditions" do
    before(:each) {@heating_circuit = double(HeatingCircuit)}
    context "when true" do
      it {allow(@heating_circuit).to receive(:default_conditions).and_return(true)}
    end

    context "when false" do
      it {allow(@heating_circuit).to receive(:default_conditions).and_return(false)}
    end
  end

  describe "#heating_curve" do
    xit {}
  end

  describe "#difference" do
    before(:each) {@heating_circuit = double(HeatingCircuit)}
    context "when calculated temperature bigger than lead temperature" do
      it "returns a positive number" do
	allow(@heating_circuit).to receive(:difference).with({calculated_temperature: 40}, {lead_temperature: 30}).and_return(10)
      end
    end
    context "when calculated temperature smaller than lead temperature" do
      it "returns a negative number" do
	allow(@heating_circuit).to receive(:difference).with({calculated_temperature: 30}, {lead_temperature: 40}).and_return(-10)
      end
    end
  end

  describe "#mixer" do
    before(:each) {@heating_circuit = double(HeatingCircuit)}
    context "when difference is greater than 2" do
      it {allow(@heating_circuit).to receive(:enable).with(:mixer)}
    end
    
    context "when difference is less than -2" do
      it {allow(@heating_circuit).to receive(:disable).with(:mixer)}
    end
  end

  describe "#enable" do
    before(:each) {@heating_circuit = double(HeatingCircuit)}
    context "pump" do
      it {allow(@heating_circuit).to receive(:enable).and_return("Enable pump")}
    end
    
    context "mixer" do
      it {allow(@heating_circuit).to receive(:enable).and_return("Enable mixer")}
    end
  end

  describe "#disable" do
    before(:each) {@heating_circuit = double(HeatingCircuit)}
    context "pump" do
      it {allow(@heating_circuit).to receive(:disable).and_return("Disable pump")}
    end
    
    context "mixer" do
      it {allow(@heating_circuit).to receive(:disable).and_return("Disable mixer")}
    end
  end

  describe "#measure" do
    xit {}
  end

  describe "#shutdown" do
    xit {}
  end

end

