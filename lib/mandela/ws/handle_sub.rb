module Mandela
  module Ws
    class HandleSub

      def self.call(msg, mconn)
        new.call(msg, mconn)    
      end

      def call(msg, mconn)
        channel = Mandela::Channel.build(msg)
        Mandela::Subscription.build(channel, mconn)

        answer = { status: :ok, msg: :subscription_done }
        mconn.ws_send(answer.to_json)
      end
    end
  end
end
  
