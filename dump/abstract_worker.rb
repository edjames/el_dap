require 'net/ldap'
require 'system_timer'

module ActiveDirectoryWrapper
  class AbstractWorker
    LDAP_ATTRS = ['cn', 'samaccountname', 'displayname', 'name', 'telephonenumber', 'userprincipalname', 'mail']
    LDAP_FILTERS = Net::LDAP::Filter.eq("objectcategory", "person")

    attr_reader :username, :password, :server_ips, :timeout, :treebase

    def initialize
      raise 'You cannot instantiate this class directly'
    end

    def validate(uname, pword)
      workers(uname, pword).each do |worker|
        begin
          SystemTimer.timeout_after(self.timeout) do
            return worker.bind
          end
        rescue Timeout::Error
          next
        end
      end
      return false
    end

    def search(search_string)
      search_result = nil
      workers(self.username, self.password).each do |worker|
        begin
          SystemTimer.timeout_after(self.timeout) do
            search_result ||= search_active_directory(worker, search_string)
          end
        rescue Timeout::Error
          next
        end
      end
      create_result_collection search_result
    end

    protected
    def workers(uname, pword)
      self.server_ips.map do |ip|
        create_worker uname, pword, ip
      end
    end

    def create_worker(uname, pword, server_ip)
      obj = Net::LDAP.new
      obj.host = server_ip
      obj.auth uname, pword
      obj
    end

    def search_active_directory(worker, search_string)
      filters = LDAP_FILTERS & Net::LDAP::Filter.eq("cn", "*#{search_string}*")
      result = worker.search(:base => self.treebase,
                             :filter => filters,
                             :attributes => LDAP_ATTRS,
                             :return_result => true)
      # search will return false if unable to bind
      # i.e. service account credentials have expired
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

