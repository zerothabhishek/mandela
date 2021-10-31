module Mandela
  class Broadcast

    def self.call(channel_label, channel_id, msg)
      payload = {}
      payload[:meta] = { label: channel_label, id: channel_id }
      payload[:msg] = msg

      Mandela.log(:Broadcast, nil, payload)

      # on_broadcast_start here !!
      Mandela.pubsub.publish(payload.to_json)
      # on_broadcast_finish here !!
    end

    def self.call1(channel, msg)
      self.call(channel.label, channel.id, msg)
    end
  end
end
