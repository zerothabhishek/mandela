require 'faye/websocket'
require 'permessage_deflate'
# require 'rack'
require 'redis'
require 'concurrent'
require 'byebug'
require 'json'

# $LOAD_PATH << File.expand_path("..", __FILE__)

require "mandela/pubsub/inform"
require "mandela/pubsub/redis"

require "mandela/ws/handle_msg"
require "mandela/ws/handle_sub"
require "mandela/ws/handle_unsub"
require "mandela/ws/handle_ws_msg"
require "mandela/ws/ws_server"

require 'mandela/broadcast'
require 'mandela/channel'
require 'mandela/channel_def'
require 'mandela/connection'
require 'mandela/consumer'
require 'mandela/main'
require 'mandela/registry'
require 'mandela/subscription'
require 'mandela/utils'
require "mandela/version"

module Mandela

  def self.register(channel_label, defn_klass)
    Mandela::Registry.register(channel_label, defn_klass)
  end

  def self.broadcast(channel_label, channel_id, msg)
    Mandela::Broadcast.call(channel_label, channel_id, msg)
  end

  def self.ws_server
    Mandela::Ws::WsServer
  end

  def self.pubsub_start_sub
    pubsub.setup_subscription
  end

  def self.pubsub
    Mandela::Pubsub::Redis
  end

  def self.executor_pool
    @@executor_pool ||= Concurrent::ThreadPoolExecutor.new(
      min_threads: 5,
      max_threads: 10,
    )
  end

  def self.log(klass, action, *args)
    Mandela::Utils.log(klass, action, *args)
  end
end
