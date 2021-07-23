
module Mandela
  module ChannelDef

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      ## -- the macros -------------------------

      # TODO: use meta programming to remove repetition
      def find_id_with(method_name)
        @find_id_with = method_name
      end

      def find_user_with(method_name)
        @find_user_with = method_name
      end

      def authenticate_with(method_name)
        @authenticate_with = method_name
      end

      def authorize_with(method_name)
        @authorize_with = method_name
      end

      def on_subscribe(method_name)
        @on_subscribe = method_name
      end

      def on_message(method_name)
        @on_message = method_name
      end

      def on_unsub(method_name)
        @on_unsub = method_name
      end

      def on_broadcast_start(method_name)
        @on_broadcast_start = method_name
      end

      def on_broadcast_finish(method_name)
        @on_broadcast_finish = method_name
      end

      def on_presence(method_name)
        @on_presence = method_name
      end

      def recur(method_name, args)
        @recur_list ||= []
        @recur_list.push({ handler: method_name }.merge(args))
      end

      # ----------------------------------------

      def _find_channel(msg, connection)
        _instance.public_send(@instantiate_with, msg, connection)
      end

      def _identify_channel(connection)
        _instance.public_send(@identify_with, connection)
      end

      def _on_message(msg, subscription)
        _instance.public_send(@on_message, msg, subscription)
      end

      # TODO: use mutex
      def _instance
        @_instance ||= self.new
      end
    end

  end
end