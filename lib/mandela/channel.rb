module Mandela
  class Channel
    attr_reader :label, :id, :channel_defn

    LOG = -> (action, *args) { Mandela::Utils.log(:Channel, action, *args) }

    def self.build(msg)
      channel_label = msg.dig('meta', 'label')
      channel_id = msg.dig('meta', 'id')

      # TODO: use channel_defn._find_channel when there is no id
      channel_defn = Mandela::Registry.find(channel_label)
      new(channel_label, channel_id, channel_defn)
    end

    # def self.build1(msg)
    #   channel_label = msg.dig('meta', 'label')
    #   channel_defn = Mandela::Registry.find(channel_label)
    #   channel_id = channel_defn._find_channel(msg, connection)

    #   new(channel_label, channel_id, channel_defn)
    # end

    def self.find_on_connection(msg, connection)
      connection
        .channels
        .detect { |ch| ch.label == msg.dig('meta', 'label') && ch.id == msg.dig('meta', 'id') }
    end

    def initialize(channel_label, channel_id, channel_defn)
      @label = channel_label        # String
      @id = channel_id              # String
      @channel_defn = channel_defn  # CollabChannel

      @channel_defn_instance = @channel_defn.new
    end

    def inspect
      "<Mandela::Channel @label=#{@label} @id=#{@id}>"
    end

    def execute(action, args)
      LOG[action, args]
      case action
      when :authenticate_with
        mconn = args
        handler = handler_for(:authenticate_with)
        send_to_handler(handler, mconn)
      when :authorize_with
        mconn = args
        handler = handler_for(:authorize_with)
        send_to_handler(handler, mconn)
      when :on_subscribe
        subsciption = args
        handler = handler_for(:on_subscribe)
        send_to_handler(handler, subsciption)
      when :on_unsub
        # TODO
      when :on_broadcast_start
        # TODO
      when :on_broadcast_finish
        # TODO
      when :on_message
        # msg = args[:msg]
        # sub = args[:sub]
        # LOG[:on_message, sub.inspect, msg]

        # @channel_defn._on_message(msg, sub)
        handler = handler_for(:on_message)
        send_to_handler(:on_message, args[:msg], args[:sub])
      end
    end

    def send_to_handler(handler, *args)
      return true if handler.nil?
      if handler.is_a?(Proc)
        handler.call(*args)
      else
        @channel_defn_instance.public_send(handler, *args)
      end
    end

    def handler_for(action)
      @channel_defn.handler_for(action)
    end
  end
end
