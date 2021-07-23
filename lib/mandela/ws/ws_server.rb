module Mandela::Ws
  OPTIONS = { :extensions => [PermessageDeflate], :ping => 5 }

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

        Mandela::Registry.register_connection(mconn)
      end

      ws.on(:message) do |event|
        log_it(:onmessage, event.data)

        # TODO: use thread pool
        Thread.new do
          Mandela::Ws::HandleWsMsg.call(event.data, mconn)
        end
      end

      ws.on(:close) do |event|
        log_it(:close, event.code, event.reason)

        Mandela::Registry.remove_connection(mconn)
        ws = nil
      end

      ws.rack_response
    end

    def log_it(klass, action, *args)
      puts ([:WsServer, action] + args).join(" ")
    end
  end
end

