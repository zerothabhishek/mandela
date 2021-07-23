module Mandela
  module Pubsub
    class Inform
      
      def self.call(data) # data: String
        puts "-> RedisPubsub: current-connections: #{Mandela::Registry.connections.count}"

        Mandela::Registry.connections.each do |id, mconn|
          mconn.handle_pubsub_message(data)
        end        
      end

    end
  end
end