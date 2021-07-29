module Mandela
  module Ws
    class HandleWsMsg

      LOG = -> (*args) { Mandela::Utils.log(:HandleWsMsg, nil, *args) }
      
      def self.call(*args)
        new.call(*args)
      end

      def call(data, mconn)

        LOG[data]

        if data == 'ping'
          mconn.ws_send('pong')
          return
        end

        msg = JSON.parse(data) rescue {}
        
        LOG[msg]

        case msg.dig('meta', 'type')
        when 'sub'    then Mandela::Ws::HandleSub.call(msg, mconn)
        when 'unsub'  then Mandela::Ws::HandleUnsub.call(msg, mconn)
        else
          Mandela::Ws::HandleMsg.call(msg, mconn)
        end
      end

    end # class
  end
end
