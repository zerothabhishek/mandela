module Mandela
  module Pubsub
    class Redis

      LOG = -> (action, *args) { Mandela::Utils.log('Pubsub:Redis', action, *args) }

      REDIS_PUBSUB_CHANNEL = "__mandela-pubsub"
      attr_reader :thread

      def self.publish(payload) # payload: JSON string
        # puts "-> RedisPubsub .publish \t #{payload}"
        LOG[:publish, payload]

        pub_connection.publish(REDIS_PUBSUB_CHANNEL, payload)
      end

      def self.pub_connection
        ::Redis.new # TODO: use connection pool
      end

      def self.sub_connection
        ::Redis.new
      end

      def self.setup_subscription
        return if @thread
        @thread = Thread.new do
          setup_subscription_blocking
        end
      end

      def self.setup_subscription_blocking
        sub_connection.subscribe(REDIS_PUBSUB_CHANNEL) do |on|

          on.subscribe do |ch, sub|
            LOG[:sub, sub]
            # Accept more subscriptions
            # watch_queue(subsription_queue) do |sub_req|
            #   sub_connection.subscribe(sub_req.channel_name) do |onx|
            #     onx.subscribe do |chx, subx|
            #     end
            #     onx.message do |chx, data|
            #     end
            #     onx.unsubscribe do |chx, data|
            #     end
            #   end
            # end
          end

          on.message do |ch, data|
            LOG[:msg, data]

            inform_ws_connections(data)
          end

          on.unsubscribe do |ch, sub|
            LOG[:unsub, sub]
          end
        end
      end

      def self.inform_ws_connections(data)
        Mandela.executor_pool.post do
          Mandela::Pubsub::Inform.call(data)
        end
        # Thread.new do
        #   Mandela::Pubsub::Inform.call(data)
        # end
      end

    end
  end
end
