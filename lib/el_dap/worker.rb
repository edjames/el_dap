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
      search_result = search(:base => treebase,
                             :filter => filters,
                             :attributes => LDAP_ATTRS,
                             :return_result => true)
      # search will return false if unable to bind
      # e.g. service account credentials have expired
      return [] unless search_result
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
