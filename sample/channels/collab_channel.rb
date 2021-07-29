class CollabChannel

  include ::Mandela::ChannelDef

  ## TODO
  # register_as :collab

  ## instance and identity

  find_id_with :find_channel
  find_user_with :current_user

  ## Auth and authz

  authenticate_with :authenticate
  authorize_with :authorize

  ## Hooks for incoming data:
  
  on_subscribe :on_subscribe
  on_message :on_message
  on_unsub :on_unsub

  ## Hooks for outgoing data:

  on_broadcast_start :before_broadcast
  on_broadcast_finish :after_broadcast
  on_presence :before_presence

  ## Recurring actions

  recur :recurring_action, every: 10

  ## -- definitions ------------------------------------

  def find_channel(msg, connection)
  end

  def current_user(connection)
  end

  def authenticate(connection)
  end

  def authorize(subscription)
  end

  def on_subscribe(subscription)
  end

  def on_message(msg, subscription)
    # puts "[CollabChannel#on_message]: #{msg}"
    Mandela.log(:CollabChannel, :on_message, msg)
    channel = subscription.channel
    Mandela.broadcast(channel.label, channel.id, msg['data'])
  end

  def on_unsub(subscription)
  end

  def before_broadcast(msg, subscription)
  end

  def after_broadcast(msg, subscription)
  end

  def before_presence(subscription)
  end

  def recurring_action
  end
end

Mandela.register('collab', CollabChannel)
