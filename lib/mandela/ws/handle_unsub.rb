module Mandela
  module Ws
    class HandleUnsub
      
      def self.call(msg, mconn)

        # TODO: persist this

        answer = { status: :ok, msg: :unsubscribe_done }
        mconn.ws_send(answer.to_json)        
      end
    end
  end
end
