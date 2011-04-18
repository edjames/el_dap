require 'spec_helper'

module ElDap
  describe ApiMethods do
    before(:each) do
      @base = mock(ElDap::Base)      
    end
    
    it "should setup a new instance of the Base class" do
      @base.should_receive(:username=).with('username')
      @base.should_receive(:password=).with('password')
      @base.should_receive(:server_ips=).with(['1.2.3.4'])
      @base.should_receive(:treebase=).with('dc=ad,dc=example,dc=com')
      ElDap::Base.should_receive(:new).and_return(@base)
      ElDap.configure do |l|
        l.username = 'username'
        l.password = 'password'
        l.server_ips = ['1.2.3.4']
        l.treebase = 'dc=ad,dc=example,dc=com'
      end
    end
    
    it "should perform the validate method on the worker" do
      ElDap::ApiMethods.class_variable_set(:@@worker, @base)
      @base.should_receive(:validate).with('username', 'password')
      ElDap.validate('username', 'password')
    end
    
    it "should perform the search method on the worker" do
      ElDap::ApiMethods.class_variable_set(:@@worker, @base)
      @base.should_receive(:search).with('search string')
      ElDap.search('search string')
    end
    
  end
end
