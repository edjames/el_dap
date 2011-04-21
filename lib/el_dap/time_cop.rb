module ElDap
  class TimeCop
    
    def self.timer
      if ruby_version < "1.9" 
        use_system_timer
      else
        use_timeout
      end
    end
    
    private
    
    def self.ruby_version
      RUBY_VERSION
    end
    
    def self.use_system_timer
      require 'system_timer'
      SystemTimer
    end
    
    def self.use_timeout
      require 'timeout'
      Timeout
    end
    
  end
end
