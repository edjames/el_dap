module ElDap
  class Base
    attr_accessor :server_ips, :username, :password, :timeout, :treebase
    
    def initialize
      @server_ips = []
      @timeout = 15
      yield(self) if block_given?
    end
    
    def validate(username, password)
      return false if Validator.blank?(username, password)
      
      @server_ips.each do |ip_address|
        begin
          Timeout::timeout(self.timeout) do
            worker = Worker.new(:username => username, :password => password, :ip_address => ip_address)
            return worker.bind
          end
        rescue Timeout::Error
          next
        end
      end
    end
    
    def search(search_string)
      return nil if Validator.blank?(search_string)
      
      search_result = []
      
      @server_ips.each do |ip_address|
        begin
          Timeout::timeout(self.timeout) do
            worker = Worker.new(:username => self.username, :password => self.password, :ip_address => ip_address)
            return worker.search_directory(search_string, self.treebase)
          end
        rescue Timeout::Error
          next
        end
      end
    end
    
  end
end
