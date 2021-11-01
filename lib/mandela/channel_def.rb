
module Mandela
  module ChannelDef

    def self.included(base)
      base.extend(ClassMethods)
      Mandela.register(base.the_label, base)
    end

    module ClassMethods

      ARG_ERR = -> (label) { "#{label}: needs a method name or a block" }

      ## -- the macros -------------------------

      def the_label
        self.to_s.gsub("Channel", "").downcase
      end

      # TODO: use meta programming to remove repetition
      def find_id_with(method_name = nil, &block)
        raise ARG_ERR[:authenticate_with] if method_name.nil? && !block_given?

        @find_id_with = method_name || block
      end

      def authenticate_with(method_name = nil, &block)
        raise ARG_ERR[:authenticate_with] if method_name.nil? && !block_given?

        @authenticate_with = method_name || block
      end

      def authorize_with(method_name = nil, &block)
        raise ARG_ERR[:authorize_with] if method_name.nil? && !block_given?

        @authorize_with = method_name || block
      end

      def on_subscribe(method_name = nil, &block)
        raise ARG_ERR[:on_subscribe] if method_name.nil? && !block_given?

        @on_subscribe = method_name || block
      end

      def on_message(method_name = nil, &block)
        raise ARG_ERR[:on_message] if method_name.nil? && !block_given?

        @on_message = method_name || block
      end

      def on_unsub(method_name = nil, &block)
        raise ARG_ERR[:on_unsub] if method_name.nil? && !block_given?

        @on_unsub = method_name || block
      end

      def on_broadcast_start(method_name = nil, &block)
        raise ARG_ERR[:on_broadcast_start] if method_name.nil? && !block_given?

        @on_broadcast_start = method_name || block
      end

      def on_broadcast_finish(method_name = nil, &block)
        raise ARG_ERR[:on_broadcast_finish] if method_name.nil? && !block_given?

        @on_broadcast_finish = method_name || block
      end

      def on_presence(method_name = nil, &block)
        raise ARG_ERR[:on_broadcast_finish] if method_name.nil? && !block_given?

        @on_presence = method_name || block
      end

      def recur(method_name, args, &block)
        raise ARG_ERR[:recur] if method_name.nil? && !block_given?

        @recur_list ||= []
        @recur_list.push({ handler: method_name }.merge(args))
      end

      # ----------------------------------------

      # def _find_channel(msg, connection)
      #   _instance.public_send(@instantiate_with, msg, connection)
      # end

      def handler_for(action)
        case action
          when :authenticate_with then @authenticate_with
          when :authorize_with then @authorize_with
          when :_on_message then @on_message
        end
      end

      # def _identify_channel(connection)
      #   _instance.public_send(@identify_with, connection)
      # end

      # def _authenticate(mconn)
      #   return true if @authenticate_with.nil?
      #   _instance.public_send(@authenticate_with, mconn)
      # end

      # def _authorize(mconn)
      #   return true if @authorize_with.nil?
      #   _instance.public_send(@authorize_with, mconn)
      # end

      # def _on_message(msg, subscription)
      #   return true if @on_message.nil?
      #   _instance.public_send(@on_message, msg, subscription)
      # end

      # TODO: use mutex
      # def _instance
      #   @_instance ||= self.new
      # end
    end

  end
end
