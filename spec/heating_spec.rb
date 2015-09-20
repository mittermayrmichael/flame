require 'spec_helper'

describe Heating do

   describe "#running?" do

     context 'when system is not running' do
       it {expect(subject.running?).to be false}
     end

     context 'when system is running' do
       before(:each) {subject.boot}
       it {expect(subject.running?).to be true}
     end

   end

   describe "#boot" do
     context 'when system is not running' do
       it {expect(subject.boot).to eql("Heating system started at #{Time.now}")}
     end
     
     context 'when system is running' do
       before(:each) {subject.boot}
       it {expect(subject.boot).to eql("Heating system runs already.")}
     end
   end

   describe "#shutdown" do
     context 'when system is running' do
       before(:each) {subject.boot}
       it {expect(subject.shutdown).to eql("Heating system shuts down.")}
     end
   end

end


