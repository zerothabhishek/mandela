module Mandela
  class Consumer
    def initialize(channel_klass, connection)
      @user_id = channel_klass.find_user(connection)
      @user_id ||= connection.cookies['mandela_token']

      @device = connection.device
    end

    def identifier
      [@user_id, @device].to_json
    end    
  end
end
