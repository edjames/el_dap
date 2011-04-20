module ElDap
  class Worker #< ::Net::LDAP
    
    def initialize(username, password, ip_address)
      self = ::Net::LDAP.new
      self.host = ip_address
      self.auth username, password
      self
    end
    
  end
end
