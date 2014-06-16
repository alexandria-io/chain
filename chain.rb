require 'sinatra'
require 'sinatra/json'
require "sinatra/config_file"
require 'sinatra/link_header'
require 'json'
require 'bitcoin-client'
require 'securerandom'

require './bitcoin_client_extensions.rb'
require './command.rb'
require './chain_api.rb'

class Chain < Sinatra::Base
  enable :logging
  set :show_exceptions, true
  set :bind, '0.0.0.0'
  #set :port, '80'

  register Sinatra::ConfigFile
  config_file './config.yml'

  get '/' do
    'hello world'
  end
  
  UNUSED_COMMANDS = %w[addmultisigaddress backupwallet createrawtransaction decoderawtransaction dumpprivkey encryptwallet getblocktemplate getrawtransaction getreceivedbyaccount getreceivedbyaddress getwork getworkex help importprivkey keypoolrefill listaccounts listreceivedbyaccount listreceivedbyaddress listsinceblock listunspent makekeypair move sendmany sendrawtransaction sendtoaddress setaccount setgenerate setmininput settxfee signmessage signrawtransaction stop validateaddress verifymessage]

  before do
    unless %w[/].include? env['REQUEST_PATH']
      if env['HTTP_CHAIN_AUTH_TOKEN'].nil? 
        halt 500, json(status: 'failure', message: 'missing HTTP_CHAIN_AUTH_TOKEN header')
      elsif env['HTTP_CHAIN_AUTH_TOKEN'] != settings.chain_auth_token
        halt 500, json(status: 'failure', message: 'invalid HTTP_CHAIN_AUTH_TOKEN header')
      end 
    end
  end
  
  
# begin api/v1/chain endpoints
  api_v1_chain_prefix = '/api/v1/chain/'
  
  UNUSED_COMMANDS.each do |unused_command|
    get "#{api_v1_chain_prefix}#{unused_command}.json" do
      begin
        command = Command.new(unused_command, params, settings)
        command.perform
        json command.result
      rescue Exception => ex
        json status: 'failure', message: ex
      end 
    end
  end

  get "#{api_v1_chain_prefix}getaccount.json" do
    begin
      command = Command.new('getaccount', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  post "#{api_v1_chain_prefix}getaccountaddress.json" do
    begin
      command = Command.new('getaccountaddress', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getaddressesbyaccount.json" do
    begin
      command = Command.new('getaddressesbyaccount', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getbalance.json" do
    begin
      command = Command.new('getbalance', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getblock.json" do
    begin
      command = Command.new('getblock', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getblockcount.json" do
    begin
      command = Command.new('getblockcount', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getblockhash.json" do
    begin
      command = Command.new('getblockhash', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getconnectioncount.json" do
    begin
      command = Command.new('getconnectioncount', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getdifficulty.json" do
    begin
      command = Command.new('getdifficulty', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getgenerate.json" do
    begin
      command = Command.new('getgenerate', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}gethashespersec.json" do
    begin
      command = Command.new('gethashespersec', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getinfo.json" do
    begin
      command = Command.new('getinfo', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getmininginfo.json" do
    begin
      command = Command.new('getmininginfo', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getnetworkhashps.json" do
    begin
      command = Command.new('getnetworkhashps', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  post "#{api_v1_chain_prefix}getnewaddress.json" do
    begin
      command = Command.new('getnewaddress', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getpeerinfo.json" do
    begin
      command = Command.new('getpeerinfo', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end
  
  get "#{api_v1_chain_prefix}getrawmempool.json" do
    begin
      command = Command.new('getrawmempool', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end 
  end

  get "#{api_v1_chain_prefix}getreceivedbyaddress.json" do
    begin
      command = Command.new('getreceivedbyaddress', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end
  end

  get "#{api_v1_chain_prefix}gettransaction.json" do
    begin
      command = Command.new('gettransaction', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end
  end

  get "#{api_v1_chain_prefix}listtransactions.json" do
    begin
      command = Command.new('listtransactions', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end
  end

  get "#{api_v1_chain_prefix}sendfrom.json" do
    begin
      command = Command.new('sendfrom', params, settings)
      command.perform
      json command.result
    rescue Exception => ex
      json status: 'failure', message: ex
    end
  end
  
  not_found do
    json status: 'failure', message: 'that endpoint doesn\'t exist'
  end
end
