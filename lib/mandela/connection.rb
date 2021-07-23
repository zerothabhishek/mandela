require 'securerandom'

module Mandela
  class Connection
    # has-many :subscriptions
    # has-many :channels via subscriptions

    attr_reader :id, :subscriptions

    def initialize(ws)
      @ws = ws
      @id = SecureRandom.hex(3)
      @subscriptions = []
    end

    def handle_pubsub_message(payload)
      if payload == 'debug'
        ws_send(payload, 1)
        return
      end

      if payload.to_s =~ /^ping/
        ws_send(payload)
        return
      end

      channel_label, channel_id = extract_channel_info(payload)
      
      puts "[Connection:#{id}:handle_pubsub_message]: #{channel_label}-#{channel_id}"

      return if channel_id.nil?
      return if channel_label.nil?

      return unless subscribed_to?(channel_label, channel_id)

      ws_send(payload)      
    end

    def extract_channel_info(payload)
      msg = JSON.parse(payload) || {}

      channel_label = msg.dig('meta', 'label')
      channel_id = msg.dig('meta', 'id')
      [channel_label, channel_id]

    rescue JSON::ParserError
      [nil, nil]
    end

    # TODO: use mutex
    def add_subscription(sub)
      @subscriptions.push(sub)
    end

    def subscribed_to?(channel_label, channel_id)
      channels
        .any? { |ch| ch.label == channel_label && ch.id == channel_id }      
    end

    def subscriptions_to(channel)
      subscriptions
        .select { |sub| sub.matching?(channel) }
    end

    def channels
      @subscriptions.map(&:channel)
    end

    def ws_send(data, debug = false)
      if debug == 1
        byebug
      end

      # puts "-> websocket.send: start: #{Time.now}"
      puts "[Connection:#{@id}:ws_send]: #{data}"

      @ws.send(data)
      # puts "-> websocket.send: done: #{Time.now}"
    end

    def cookies
      # TODO
    end

    def headers
      # TODO
    end

    def inspect
      "<Mandela::Connection @id=#{@id} >"
    end

    def method_missing(method_name, *args, &block)
      @ws.public_send(method_name, *args, &block)
    end
  end
end
