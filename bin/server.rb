#!/usr/bin/env ruby

require "bundler/setup"
require "mandela"

require File.expand_path("../../sample/channels/collab_channel.rb", __FILE__)

port   = ARGV[0] || 9292
secure = false  # ARGV[1] == 'tls'
engine = 'puma' # ARGV[2] || 'thin'
# spec   = File.expand_path('../../spec', __FILE__)

Faye::WebSocket.load_adapter(engine)

require 'puma/binder'
require 'puma/events'

Mandela.pubsub_start_sub
App = Mandela.ws_server

puts "Starting Puma with #{App}"

events = Puma::Events.new($stdout, $stderr)
binder = Puma::Binder.new(events)
binder.parse(["tcp://0.0.0.0:#{ port }"], App)
server = Puma::Server.new(App, events)
server.binder = binder
server.run.join
