require 'spec_helper'

module ElDap
  describe Base do
    before(:each) do
      allow_message_expectations_on_nil
      @instance = Base.new do |i|
        i.username = 'name'
        i.password = 'password'
        i.server_ips = ['1.1.1.1', '2.2.2.2']
        i.timeout = 10
        i.treebase = 'tree'
      end
      Validator.stub!(:blank?)
      Worker.stub!(:new)
    end
      
    it "should initialize with a block" do
      @instance.username.should == 'name'
      @instance.password.should == 'password'
      @instance.server_ips.should == ['1.1.1.1', '2.2.2.2']
      @instance.timeout.should == 10
      @instance.treebase.should == 'tree'
    end

    describe '#Validate' do
      before(:each) do
        @worker = mock(Worker, :bind => true)
        Worker.stub!(:new).and_return(@worker)
      end
      
      it "should check that username and password are not blank" do
        Validator.should_receive(:blank?).and_return(true)
        @instance.validate(nil, nil).should be_false
      end
      
      it "should create a new worker for the first ip address" do
        Worker.should_receive(:new).and_return(@worker)
        @instance.validate('name', 'password')
      end
      
      it "should return the result of the validation" do
        @instance.validate('name', 'password').should be_true
      end
      
      it "should use the second ip address when the first one times out" do
        @worker.should_receive(:bind).ordered.and_raise(Timeout::Error)
        @worker.should_receive(:bind).ordered.and_return(true)
        @instance.validate('name', 'password').should be_true
      end
    end
    
    describe '#Search' do
      it "should check that username and password are not blank" do
        Validator.should_receive(:blank?).and_return(true)
        @instance.search(nil).should be_nil
      end
      
      it "should create a new worker for the first ip address" do
        @worker = mock(Worker, :search_directory => [], :bind => true)
        Worker.should_receive(:new).and_return(@worker)
        @instance.search('name')
      end
      
      it "should return the result of the search" do
        @worker = mock(Worker, :search_directory => ['result'], :bind => true)
        Worker.stub!(:new).and_return(@worker)
        @instance.search('name').should == ['result']
      end
      
      it "should use the second ip address when the first one times out" do
        @worker.stub(:bind).and_return(true)
        @worker.should_receive(:search_directory).ordered.and_raise(Timeout::Error)
        @worker.should_receive(:search_directory).ordered.and_return(['result'])
        @instance.search('name').should == ['result']
      end
      
      it "should throw an exception if the search user credentials are invalid" do
        @worker.should_receive(:bind).and_return(false)
        lambda{ @instance.search('name') }.should raise_error(InvalidCredentialsError, 'The user credentials provided are invalid')
      end
    end
    
  end
end
