module ElDap
  class Base
    include Constants
    
    attr_accessor :server_ips, :username, :password, :timeout, :treebase
    
    def initialize
      @server_ips = []
      @timeout = 15
      yield(self) if block_given?
    end
    
    def validate(uname, pword)
      return false if uname.nil? || uname.empty? || pword.nil? || pword.empty?
      workers(uname, pword).each do |worker|
        begin
          Timeout::timeout(self.timeout) do
            return worker.bind
          end
        rescue Timeout::Error
          next
        end
      end
      false
    end
    
    def search(search_string)
      return nil if search_string.nil? || search_string.empty?
      search_result = nil
      workers(self.username, self.password).each do |worker|
        begin
          Timeout::timeout(self.timeout) do
            search_result ||= search_active_directory(worker, search_string)
          end
        rescue Timeout::Error
          next
        end
      end
      create_result_collection search_result
    end
    
    private
    def workers(uname = self.username, pword = self.password)
      self.server_ips.map do |ip|
        create_worker uname, pword, ip
      end
    end

    def create_worker(username, password, ip_address)
      Worker.new(:username => username, :password => password, :ip_address => ip_address)
    end
    
    def search_active_directory(worker, search_string)
      filters = LDAP_FILTERS & ::Net::LDAP::Filter.eq(LDAP_SEARCH_FIELD, "*#{search_string}*")
      result = worker.search(:base => self.treebase,
                             :filter => filters,
                             :attributes => LDAP_ATTRS,
                             :return_result => true)
      # search will return false if unable to bind
      # e.g. service account credentials have expired
      result || []
    end

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
