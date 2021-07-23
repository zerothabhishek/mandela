module Mandela
  class Broadcast

    def self.call(channel_label, channel_id, msg)
      payload = {}
      payload[:meta] = { label: channel_label, id: channel_id }
      payload[:data] = msg

      puts "[Mandela.broadcast] payload: #{payload}"

      pubsub.publish(payload.to_json)
    end

    def self.call1(channel, msg)
      self.call(channel.label, channel.id, msg)
    end
  end
end