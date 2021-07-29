module Mandela
  module Ws
    class HandleSub

      LOG = -> (*args) { Mandela.log(:HandleSub, nil, *args.map(&:inspect)) }

      def self.call(msg, mconn)
        new.call(msg, mconn)    
      end

      def call(msg, mconn)
        channel = Mandela::Channel.build(msg)
        LOG[channel]

        sub = Mandela::Subscription.build(channel, mconn)
        LOG[sub]

        answer = { status: :ok, msg: :subscription_done }
        mconn.ws_send(answer.to_json)
      end
    end
  end
end
  
