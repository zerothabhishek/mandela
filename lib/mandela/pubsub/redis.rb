module Mandela
  module Pubsub
    class Redis

      REDIS_PUBSUB_CHANNEL = "__mandela-pubsub"
      attr_reader :thread

      def self.call(ws)
        new.call(ws)
      end

      def self.publish(payload) # payload: JSON string
        puts "-> RedisPubsub .publish \t #{payload}"

        pub_connection.publish(REDIS_PUBSUB_CHANNEL, payload)
      end

      def self.init
        return if @thread
        @thread = Thread.new do
          setup
        end
      end

      def self.pub_connection
        ::Redis.new # TODO: use connection pool
      end

      def self.sub_connection
        ::Redis.new
      end

      def self.setup_subscription
        sub_connection.subscribe(REDIS_PUBSUB_CHANNEL) do |on|

          on.subscribe do |ch, sub|
            puts "-> RedisPubsub: sub: #{ch} #{sub}"
          end

          on.message do |ch, data|
            puts "-> RedisPubsub: msg: #{ch} #{data}"

            inform_ws_connections(data)
          end

          on.unsubscribe do |ch, sub|
            puts "-> RedisPubsub: unsub: #{ch} #{sub}"
          end
        end
      end

      def self.inform_ws_connections(data)
        Mandela::Pubsub::Inform.call(data)
      end
    end
  end
end