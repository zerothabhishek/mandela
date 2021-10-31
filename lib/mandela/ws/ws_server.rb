module Mandela::Ws
  OPTIONS = { :extensions => [PermessageDeflate] }

  class WsServer
    def self.call(env)
      new.call(env)
    end

    def self.log(x)
      puts "self.log: #{x}"
    end

    def call(env)
      unless Faye::WebSocket.websocket?(env)
        [200, {"Content-Type" => "text/plain"}, ["Mandela!"]]
      end

      mconn = nil
      ws = Faye::WebSocket.new(env, nil, OPTIONS) # Blocks here

      ws.on(:open) do |event|
        mconn = Mandela::Connection.new(ws)
        log_it(:open, mconn.id)

        # TODO: What if the connection never tries a subsciption
        # How long can we keep a connection open ?
        Mandela::Registry.register_connection(mconn)
      end

      ws.on(:message) do |event|
        log_it(:onmessage, event.data)

        # ws.send("Got it!: #{Time.now}")
        handle_msg(event, mconn)
      end

      ws.on(:close) do |event|
        log_it(:close, event.code, event.reason)

        Mandela::Registry.remove_connection(mconn)
        ws = nil
      end

      ws.rack_response
    end

    def log_it(action, *args)
      Mandela::Utils.log(:WsServer, action, *args)
    end

    def handle_msg(event, mconn)
      # Thread.new do
      #   Mandela::Ws::HandleWsMsg.call(event.data, mconn)
      # end
      Mandela.executor_pool.post do
        Mandela::Ws::HandleWsMsg.call(event.data, mconn)
      rescue => e
        log_it(:handle_msg, e.message)
      end
    end
  end
end
