require 'spec_helper'

module ElDap
  describe TimeCop do
    
    it "should use the SystemTimer gem when Ruby version is 1.8" do
      TimeCop.should_receive(:ruby_version).and_return('1.8')
      TimeCop.should_receive(:use_system_timer)
      TimeCop.timer
    end
    
    it "should use the SystemTimer gem when Ruby version is 1.9" do
      TimeCop.should_receive(:ruby_version).and_return('1.9')
      TimeCop.should_receive(:use_timeout)
      TimeCop.timer
    end
    
  end
end
