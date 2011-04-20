module ElDap
  class Validator
    
    def self.blank?(*strings)
      strings.inject(false) do |result, s|
        result || s.nil? || s.empty?
      end
    end
    
  end
end
