module Bitcoin
  class Client
    def self.local(settings)
      return Bitcoin::Client.new(settings.chain_rpc_user, settings.chain_rpc_password,
        { host: '127.0.0.1', port: settings.chain_port, ssl: false} )
    end
  end
end
