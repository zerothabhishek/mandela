module Mandela
  class Channel
    attr_reader :label, :id, :channel_defn

    LOG = -> (action, *args) { Mandela::Utils.log(:Channel, action, *args) }

    def self.build(msg)
      channel_label = msg.dig('meta', 'label')
      channel_id = msg.dig('meta', 'id')

      channel_defn = Mandela::Registry.find(channel_label)
      new(channel_label, channel_id, channel_defn)
    end

    def self.build1(msg)
      channel_label = msg.dig('meta', 'label')
      channel_defn = Mandela::Registry.find(channel_label)
      channel_id = channel_defn._find_channel(msg, connection)

      new(channel_label, channel_id, channel_defn)
    end

    def self.find_on_connection(msg, connection)
      connection
        .channels
        .detect { |ch| ch.label == msg.dig('meta', 'label') && ch.id == msg.dig('meta', 'id') }
    end

    def initialize(channel_label, channel_id, channel_defn)
      @label = channel_label        # String
      @id = channel_id              # String
      @channel_defn = channel_defn  # Mandela::ChannelDef
    end

    def inspect
      "<Mandela::Channel @label=#{@label} @id=#{@id}>"
    end

    def execute(action, args)
      case action
      when :on_message
        msg = args[:msg]
        sub = args[:sub]
        LOG[:on_message, sub.inspect, msg]
        
        @channel_defn.public_send(:_on_message, msg, sub)  
      end
    end
  end
end