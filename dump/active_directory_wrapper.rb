module ActiveDirectoryWrapper
  class InvalidDomainError < StandardError;
  end

  class Worker
    def initialize(domain_name)
      @domain_name = domain_name.downcase
      case @domain_name.to_sym
        when :ad
          @worker = InternalWorker.new
        when :ext
          @worker = ExternalWorker.new
        else
          raise InvalidDomainError, 'Unrecognised domain name'
      end
    end

    def validate(uname, pword)
      return false if uname.blank? || pword.blank?
      @worker.validate("#{@domain_name}\\#{uname}", pword)
    end

    def search(search_string)
      return nil if search_string.blank?
      @worker.search(search_string)
    end
  end
end

