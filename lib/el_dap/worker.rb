module ElDap
  class Worker < ::Net::LDAP
    include Constants
    
    def initialize(args = {})
      super args
      self.host = args[:ip_address]
      self.auth args[:username], args[:password]
      self
    end
    
    def search_directory(search_string, treebase)
      filters = LDAP_FILTERS & ::Net::LDAP::Filter.eq(LDAP_SEARCH_FIELD, "*#{search_string}*")
      result = search(:base => treebase,
                             :filter => filters,
                             :attributes => LDAP_ATTRS,
                             :return_result => true)
      # search will return false if unable to bind
      # e.g. service account credentials have expired
      result || []
    end
    
  end
end
