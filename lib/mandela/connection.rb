require 'securerandom'

module Mandela
  class Connection

    LOG = -> (action, id, *args) { Mandela::Utils.log(:Connection, action, *[id, args]) }

    attr_reader :id, :subscriptions, :env, :ws

    def initialize(ws)
      @ws = ws
      @env = ws.env
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

      # puts "[Connection:#{id}:handle_pubsub_message]: #{channel_label}-#{channel_id}"
      LOG[:handle_pubsub_message, id, channel_label, channel_id]

      return if channel_id.nil?
      return if channel_label.nil?

      return unless subscribed_to?(channel_label, channel_id)

      payload_h = JSON.parse(payload) || {}
      payload_h['meta'] ||= {}
      payload_h['meta']['t'] = Time.now
      payload = payload_h.to_json

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

    def deny(reason, channel)
      LOG[:deny, reason]
      answer = { meta: { label: channel.label, id: channel.id, status: :denied }, msg: reason }
      ws_send(answer.to_json)
      close(reason)
    end

    def close(reason)
      @ws.close(4001, reason)
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

    def ws_send(data, debug = false) # data: String
      if debug == 1
        byebug
      end

      LOG[:ws_send, @id, Time.now.inspect, data]

      @ws.send(data)
    end

    def cookies
      # (@env["HTTP_COOKIE"] || "").split("; ").map{|s| s.split("=")}.to_h
      request.cookies
    end

    def headers
      # ENV keys beginning in HTTP are headers
      # @env.keys
      #   .select { |k| k =~ /^HTTP_/ }
      #   .map { |k| [k, v] }
      #   .to_h
      request.headers
    end

    def session
      request.session
    end

    def request
      @request ||= begin
        environment = Rails.application.env_config.merge(@env) \
          if defined?(Rails.application) && Rails.application
        ActionDispatch::Request.new(environment || @env)
      end
    end

    def inspect
      "<Mandela::Connection @id=#{@id} >"
    end

    def method_missing(method_name, *args, &block)
      @ws.public_send(method_name, *args, &block)
    end
  end
end
