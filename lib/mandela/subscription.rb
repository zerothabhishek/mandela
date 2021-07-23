module Mandela
  class Subscription
    #
    # has-one :channel
    # belongs-to :connection
    # belongs-to :consumer via :connection
    #
    attr_reader :channel, :consumer, :connection

    def self.build(channel, connection)
      sub = new(channel, connection)
      
      connection.add_subscription(sub)
      sub.persist
      sub.execute_callbacks
      sub
    end

    def initialize(channel, connection)
      @channel = channel
      @connection = connection
    end

    def persist
      RegisterSubscription.call(self)
    end

    def execute_callbacks
      @channel.execute(:on_subscribe, self)
    end

    def matching?(channel)
      @channel.label == channel.label && @channel.id == channel.id
    end

    def inspect
      "<Mandela::Subscription @channel=#{@channel} @connection=#{@connection} >"
    end
  end

  class RegisterSubscription    
    def self.call(subscription)
      # channel = subscription.channel

      # set_name = "subs-for-#{channel.label}-#{channel.id}"
      # new_value = subscription.consumer.identifier

      # # TODO: use sorted-sets instead
      # Mandela.redis.sadd(set_name, new_value)
    end
  end
end
