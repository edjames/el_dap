module ActiveDirectoryWrapper
  class InternalWorker < AbstractWorker

    def initialize
      @server_ips = ['10.193.152.52', '10.193.168.52']
      @username = 'LONRisk.Service@ad.insidemedia.net'
      @password = 'Pa$$w0rd'
      @timeout = 15.seconds
      @treebase = 'dc=ad,dc=insidemedia,dc=net'
    end
    
  end
end

