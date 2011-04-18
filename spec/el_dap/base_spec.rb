require 'spec_helper'

module ElDap
  describe Base do
    
    before(:each) do
      @instance = Base.new
      @ldap = mock(Net::LDAP)
    end

    describe "ElDap check for blank parameters" do
      it "should not attempt validation if username or password are blank" do
        @instance.validate('username', '').should be_false
        @instance.validate('username', nil).should be_false
        @instance.validate('', 'password').should be_false
        @instance.validate(nil, 'password').should be_false
        @instance.validate('', '').should be_false
        @instance.validate(nil, nil).should be_false
      end

      it "should not attempt to search if no search criteria are provided" do
        @worker.should_not_receive(:search)
        @instance.search('').should be_false
        @instance.search(nil).should be_nil
      end
    end

    describe "protected methods" do
      it "should create an internal worker for each ip address" do
        @instance.stub!(:server_ips).and_return(['1.1.1.1', '2.2.2.2'])
        @instance.should_receive(:create_worker).with('username', 'password', '1.1.1.1').and_return('worker1')
        @instance.should_receive(:create_worker).with('username', 'password', '2.2.2.2').and_return('worker2')
        @instance.send(:workers, 'username', 'password').should == ['worker1', 'worker2']
      end

      it "should create a Net::LDAP instance with the correct parameters" do
        Net::LDAP.should_receive(:new).and_return(@ldap)
        @ldap.should_receive(:host=).with('1.1.1.1')
        @ldap.should_receive(:auth).with(/username/, /password/)
        @instance.send(:create_worker, 'username', 'password', '1.1.1.1').should == @ldap
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

      describe "search_active_directory method" do
        it "should search active directory using the correct filters and parameters" do
          filter1 = Net::LDAP::Filter.eq("objectcategory", "person")
          filter2 = Net::LDAP::Filter.eq("cn", "*search-string*")
          @ldap.should_receive(:search).with(
            :base => @instance.treebase,
            :filter => filter1 & filter2,
            :attributes => Base.const_get('LDAP_ATTRS'),
            :return_result => true
          ).and_return(['result'])
          @instance.send(:search_active_directory, @ldap, 'search-string').should == ['result']
        end

        it "should return a valid result when search cannot bind to the domain" do
          @ldap.should_receive(:search).and_return(false)
          @instance.send(:search_active_directory, @ldap, 'search-string').should == []
        end
      end

      describe "validate method" do
        it "should attempt validation when username and password are provided" do
          @instance.should_receive(:workers).with(/username/, /password/).and_return([@ldap])
          @ldap.should_receive(:bind).and_return(true)
          @instance.validate('username', 'password').should be_true
        end

        it "should stop the validation cycle when the first result if received" do
          ldap2 = mock(Net::LDAP)
          ldap2.should_not_receive(:bind)
          @ldap.should_receive(:bind).and_return(true)
          @instance.stub!(:workers).and_return([@ldap, ldap2])
          @instance.validate('username', 'password').should be_true
        end

        it "should return false when a timeout occurs" do
          @instance.stub!(:workers).and_return([@ldap])
          @ldap.should_receive(:bind).and_raise(Timeout::Error)
          @instance.validate('username', 'password').should be_false
        end
      end

      describe 'search method' do
        it "should complete gracefully if invalid credentials are used for search (search returns false)" do
          @instance.should_receive(:workers).and_return([@ldap])
          @ldap.should_receive(:search).and_return(false)
          @instance.search('string').should == []
        end

        it "should sanitize the Net::LDAP search result into an array of generic structures" do
          @instance.should_receive(:workers).and_return([])
          @instance.should_receive(:create_result_collection).and_return([])
          @instance.search('search-string').should == []
        end
      end
    end

  end
end
