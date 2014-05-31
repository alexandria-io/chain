require 'bitcoin-client'
Dir['./coin_config/*.rb'].each {|file| require file }
require './bitcoin_client_extensions.rb'
class Command
  attr_accessor :result, :action

  COMMANDS = %w[addmultisigaddress backupwallet createrawtransaction decoderawtransaction dumpprivkey encryptwallet getaccount getaccountaddress getaddressesbyaccount getbalance getblock getblockcount getblockhash getblocktemplate getconnectioncount getdifficulty getgenerate gethashespersec getinfo getmininginfo getnetworkhashps getnewaddress getpeerinfo getrawmempool getrawtransaction getreceivedbyaccount getreceivedbyaddress gettransaction getwork getworkex help importprivkey keypoolrefill listaccounts listreceivedbyaccount listreceivedbyaddress listsinceblock listtransactions listunspent makekeypair move sendfrom sendmany sendrawtransaction sendtoaddress setaccount setgenerate setmininput settxfee signmessage signrawtransaction stop validateaddress verifymessage]

  def initialize(command, request_params, settings)
    puts request_params
    #@coin_config_module = Kernel.const_get ENV['COIN'].capitalize

    @command = command
    @settings = settings
    @result = {}

    case command
    when 'getaccountaddress'
      if request_params['account'].nil?
        @account = SecureRandom.hex(32)
      else
        @account = request_params['account']
      end
    when 'getaccount'
      raise 'address parameter required' if request_params['address'].nil?
      @address = request_params['address']
    when 'getaddressesbyaccount'
      raise 'account parameter required' if request_params['account'].nil?
      @account = request_params['account']
    when 'getbalance'
      raise 'account parameter required' if request_params['account'].nil?
      @account = request_params['account']
      @minconf = request_params['minconf'].nil? ? '' : request_params['minconf']
    when 'getblock'
      raise 'hash parameter required' if request_params['hash'].nil?
      @hash = request_params['hash']
    when 'getblockhash'
      if request_params['index'].nil?
        @index = SecureRandom.hex(32)
      else
        @index = request_params['index']
      end
    when 'getnewaddress'
      if request_params['account'].nil?
        @account = ''
      else
        @account = request_params['account']
      end
    end
  end

  def perform
    if COMMANDS.include?(@command)
      self.send("#{@command}".to_sym)
    else
      raise 'That command doesn\'t exist'
    end
  end

  def client
    @client ||= Bitcoin::Client.local @settings
  end

  %w[addmultisigaddress backupwallet createrawtransaction decoderawtransaction dumpprivkey encryptwallet getblocktemplate getrawtransaction getreceivedbyaccount getreceivedbyaddress gettransaction getwork getworkex help importprivkey keypoolrefill listaccounts listreceivedbyaccount listreceivedbyaddress listsinceblock listtransactions listunspent makekeypair move sendfrom sendmany sendrawtransaction sendtoaddress setaccount setgenerate setmininput settxfee signmessage signrawtransaction stop validateaddress verifymessage].each do |action|
    define_method(action) do 
      @result[:status] = 'success'
      @result[:command] = @command
      @result[:message] = 'This command isn\'t supported currently.'
    end
  end

  def getaccount
    @result[:status] = 'success'
    @result[:address] = client.getaccount @address
  end

  def getaccountaddress
    @result[:status] = 'success'
    @result[:account] = @account
    @result[:accountaddress] = client.getaccountaddress @account
  end

  def getaddressesbyaccount
    @result[:status] = 'success'
    @result[:addresses] = client.getaddressesbyaccount @account
  end

  def getbalance
    @result[:status] = 'success'
    @result[:balance] = client.getbalance @account, @minconf.to_i
  end

  def getblock
    @result[:status] = 'success'
    @result[:block] = client.getblock @hash
  end

  def getblockcount
    @result[:status] = 'success'
    @result[:blockcount] = client.getblockcount 
  end

  def getblockhash
    @result[:status] = 'success'
    @result[:blockhash] = client.getblockhash @index.to_i
  end

  def getconnectioncount
    @result[:status] = 'success'
    @result[:connectioncount] = client.getconnectioncount
  end

  def getdifficulty
    @result[:status] = 'success'
    @result[:difficulty] = client.getdifficulty
  end

  def getgenerate
    @result[:status] = 'success'
    @result[:generate] = client.getgenerate
  end

  def gethashespersec
    @result[:status] = 'success'
    @result[:hashespersec] = client.gethashespersec
  end

  def getinfo
    @result[:status] = 'success'
    @result[:info] = client.getinfo
  end

  def getmininginfo
    @result[:status] = 'success'
    @result[:mininginfo] = client.getmininginfo
  end

  # TODO: pass in [blocks]
  def getnetworkhashps 
    @result[:status] = 'success'
    @result[:networkhashps] = client.getnetworkhashps
  end

  def getnewaddress
    @result[:status] = 'success'
    @result[:address] = client.getnewaddress @account
  end

  def getpeerinfo
    @result[:status] = 'success'
    @result[:peerinfo] = client.getpeerinfo
  end

  def getrawmempool
    @result[:status] = 'success'
    @result[:rawmempool] = client.getrawmempool
  end
end
