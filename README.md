# Mandela

Mandela is a WebSocket pub-sub library for Ruby on  Rails. Similar to Actioncable with some interesting differences. The goal is to be simpler and support more features.

Note: The code is experimental at the moment, and might break.

## Usage

- Define a channel

```
class RandomChannel # => default label will be 'random'
  include ::Mandela::ChannelDef

  on_message do |msg, sub|
    Mandela.broadcast(sub.channel.label, sub.channel.id, msg['msg'])
  end
end
```

- Subscribe in Javascript

```
  import Mandela from "mandela";

  Mandela.setUrl("ws://localhost:9292")
  const channel = { label: 'random', id: '125' }
  Mandela.subscribe(channel, {
    received(data) {
      insertInDom(data)
    }
  })

```

- Broadcast from anywhere in your app:

```
  ## Mandela identifies channels with a label and an id
  channel = [ channel.label, channel.id ]
  Mandela.broadcast(channel, msg)
```

- Add more functionality: auth, authorization, callback hooks

```
  class RandomChannel
    include ::Mandela::ChannelDef

    on_message { |msg, sub| ... }

    authenticate_with do |conn|
      connection.cookies['sender'].in?(%w[ballu mallu kallu])
    end

    ## The callbacks

    on_subscribe { |sub| ... }
    on_unsub { |sub| ... }
    on_broadcast_start { |sub| ... }
    on_broadcast_finish { |sub| ... }

    ## Recurring actions

    recur(every: 10) do |sub|
      # Do this every 10 seconds
      Mandela.broadcast(sub.channel, { hola: :again })
    end

    ## handlers can be defined as methods too
    authorize_with :authorize

    def authorize
      :ok
    end
  end
```


## Differences from ActionCable

- Mandela identifies a channel with a label and an id. Label identifies the definition for the channel (like RandomChannel above), and the id points to the instance. For example, for the #general channel in my company's Slack, the label could be '#general', but the specific instance for my team might be identified by another, database backed ID. So in Mandela, you create a GeneralChannel to defined behavior for the channel, and have its various instances stored in the DB.

- There is no `stream_from`. When we subscribe to a channel, we provide the label and id to identify the exact channel instance, and that's where we stream from.

- The authentication API is a bit more simplified. In ActionCable you setup identifiers at connection level, and that's where auth happens too. Here auth happens at subscription level, and can be different for each channel.

- Identification happens differently. TODO: add more details

- `here_now` is supported. TODO: add more details
