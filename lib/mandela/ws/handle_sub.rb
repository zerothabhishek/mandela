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

        unless channel.execute(:authenticate_with, mconn)
          mconn.deny(:authentication_failed, channel)
          return
        end

        unless channel.execute(:authorize_with, mconn)
          mconn.deny(:not_authorized, channel)
          return
        end

        LOG[channel, :auth_done, :authz_done]

        sub = Mandela::Subscription.build(channel, mconn)
        LOG[sub]

        answer = { meta: { label: channel.label, id: channel.id }, msg: :subscription_done }
        mconn.ws_send(answer.to_json)
      end

    end
  end
end
