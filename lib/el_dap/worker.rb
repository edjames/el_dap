module ElDap
  class Worker < ::Net::LDAP
    
    def initialize(args = {})
      super args
      self.host = args[:ip_address]
      self.auth args[:username], args[:password]
      self
    end
    
  end
end
