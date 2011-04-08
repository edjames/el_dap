module ActiveDirectoryWrapper
  class ExternalWorker < AbstractWorker

    def initialize
      @server_ips = ['10.2.189.72']
      @username = 'LONRisk.Service@ext.ad.insidemedia.net'
      @password = 'Pa$$w0rd'
      @timeout = 15.seconds
      @treebase = 'dc=ext,dc=ad,dc=insidemedia,dc=net'
    end
    
  end
end

