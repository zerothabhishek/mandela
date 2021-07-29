module Mandela
  module Ws
    class HandleMsg

      LOG = -> (entity, *args) { Mandela::Utils.log(:HandleMsg, nil, entity, *args) }

      def self.call(*args)
        new.call(*args)
      end

      #
      # - msg should contain the channel-id
      # - Among all channels attached to the connections,
      #    find the channel that matches the channel-id
      # - execute the :on_message handler on the channel
      # - execute other callbacks if any 
      # 
      def call(msg, connection) # msg: String connection: Mandela::Connection
        # return unless msg['id']
        #
        # channel = Mandela::Channel.find(msg, connection)
        # channel
        #   .execute(:on_message, { msg: msg, connection: connection })

        channel = Mandela::Channel.find_on_connection(msg, connection)
        LOG[:channel, channel.inspect]
        
        return unless channel

        subs = connection.subscriptions_to(channel)
        LOG[:subs, subs.map(&:inspect)]

        subs.each do |sub|
          channel.execute(:on_message, msg: msg, sub: sub)
        end
      end
    end # class
  end
end
