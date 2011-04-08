#Dir[File.expand_path(File.dirname(__FILE__) + "/../lib/base.rb")].each {|f| require f}
#Dir[File.expand_path(File.dirname(__FILE__) + "/../lib/*.rb")].each {|f| require f}

require 'el_dap/api_methods'
require 'el_dap/base'

module ElDap
  extend(ApiMethods)
end
