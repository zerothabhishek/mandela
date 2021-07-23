module Mandela
  module Ws
    class HandleWsMsg
      
      def self.call(*args)
        new.call(*args)
      end

      def call(data, mconn)
        msg = JSON.parse(data) rescue {}
        msg = msg.with_indifferent_access

        case msg.dig(:meta, :type)

        when 'sub'
          Mandela::Ws::HandleSub.call(msg, mconn)

        when 'unsub'
          Mandela::Ws::HandleUnsub.call(msg, mconn)

        else
          Mandela::Ws::HandleMsg.call(msg, mconn)
        end
      end
    end # class
  end
end
