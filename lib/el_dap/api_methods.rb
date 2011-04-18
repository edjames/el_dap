module ElDap
  module ApiMethods
    
    def configure
      @@worker = Base.new
      yield(@@worker)
    end
    
    def validate(username, password)
      @@worker.validate(username, password)
    end
    
    def search(search_string)
      @@worker.search(search_string)
    end
    
  end
end
