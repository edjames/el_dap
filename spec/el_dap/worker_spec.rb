require 'spec_helper'

module ElDap
  describe Worker do
    before(:each) do
      @instance = Worker.new(:ip_address => '1.1.1.1', :username => 'name', :password => 'password')
    end
    
    it "should instantiate with the correct arguments" do
      @instance.host.should == '1.1.1.1'
      @instance.instance_variable_get(:@auth).should == {:method=>:simple, :username=>"name", :password=>"password"}
    end
    
    it "should search the directory using the correct filters and parameters" do
      filter1 = Net::LDAP::Filter.eq("objectcategory", "person")
      filter2 = Net::LDAP::Filter.eq("cn", "*string*")
      @instance.should_receive(:search).with(
        :base => 'treebase',
        :filter => filter1 & filter2,
        :attributes => Worker.const_get('LDAP_ATTRS'),
        :return_result => true
      ).and_return([])
      @instance.search_directory('string', 'treebase').should == []
    end
    
    it "should transform a search result into a collection of structs" do
      @instance.stub!(:create_struct).and_return('struct')
      @instance.send(:create_result_collection, ['result']).should == ['struct']
    end

    it "should create a struct from a search result hash" do
      search_result = {:cn => ['cn'], :mail => ['mail']}
      struct = OpenStruct.new(:cn => 'cn',:mail => 'mail')
      @instance.send(:create_struct, search_result).should == struct
    end
    
    it "should complete gracefully if invalid credentials are used for search (search returns false)" do
      @instance.should_receive(:search).and_return(false)
      @instance.search_directory('string', 'treebase').should == []
    end
    
  end
end

