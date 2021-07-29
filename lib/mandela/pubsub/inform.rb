module Mandela
  module Pubsub
    class Inform
      LOG = -> (*args) { Mandela::Pubsub::Redis::LOG.call(*args) }
      
      def self.call(data) # data: String
        LOG[:connections_count, Mandela::Registry.connections.count]

        # TODO: optimize this
        Mandela::Registry.connections.each do |id, mconn|
          mconn.handle_pubsub_message(data)
        end        
      end

    end
  end
end