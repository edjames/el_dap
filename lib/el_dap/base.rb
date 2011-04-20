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
      false
    end
    
    def search(search_string)
      return nil if Validator.blank?(search_string)
      
      search_result = []
      
      @server_ips.each do |ip_address|
        begin
          Timeout::timeout(self.timeout) do
            worker = Worker.new(:username => self.username, :password => self.password, :ip_address => ip_address)
            search_result += worker.search_directory(search_string, self.treebase)
          end
        rescue Timeout::Error
          next
        end
      end
      create_result_collection search_result
    end
    
    private

    def create_result_collection(collection = [])
      collection ||= []
      collection.map { |entry| create_struct entry }
    end

    def create_struct(hash = {})
      key_values = {}
      hash.each{|k, v| key_values[k] = v[0]}
      OpenStruct.new(key_values)
    end
    
  end
end
