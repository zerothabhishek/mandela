module Mandela
  class Registry # Rename to ProcessGlobal
    REGISTERED_CHANNELS = {}
    REGISTERED_CONNECTIONS = {}

    # TODO: make thread safe
    def self.set(channel_label, defn)
      REGISTERED_CHANNELS[channel_label] = defn
    end

    def self.register(channel_label, defn_klass)
      set(channel_label, defn_klass)
    end

    def self.register_connection(conn)
      REGISTERED_CONNECTIONS[conn.id] = conn
    end

    def self.remove_connection(conn)
      REGISTERED_CONNECTIONS.delete(conn.id)
    end

    def self.connections
      REGISTERED_CONNECTIONS
    end

    def self.find(channel_label)
      REGISTERED_CHANNELS[channel_label]
    end
  end

#   class ChannelDefinition

#     def intialize(channel_label, block)
#       @channel_label = channel_label
#       @block = block
#     end

#     def build
#       @block.call
#     end

#     def instantiate_with(&:block)
#       set(:instantiate_with, block)
#     end

#     def identify_with(&:block)
#       set(:identify_with, block)
#     end

#     def authenticate_with(&:block)
#       set(:identify_with, block)
#     end

#     def on_subscribe(&:block)
#       set(:on_subscribe, block)
#     end

#     def on_unsub(&:block)
#       set(:on_unsub, block)
#     end

#     def on_message(&:block)
#       set(:on_message, block)
#     end

#     def on_starting_broadcast(&:block)
#       set(:on_starting_broadcast, block)
#     end

#     def on_broadcast_done(&:block)
#       set(:on_broadcast_done, block)
#     end

#     def on_presence(&:block)
#       set(:on_presence, block)
#     end

#     def recur(args, &:block)
#       set(:recurrance, block, args)
#     end
#   end


end