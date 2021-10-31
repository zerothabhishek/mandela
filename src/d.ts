interface ChannelT {
  label: string,
  id: string
}

interface MsgMeta {
  type?: string,
  label: string,
  id: string
}

interface ConnectionT {

}

interface SubscriptionCallbacksT {
  connected: Function,
  disconnected: Function,
  received: Function
}

// interface SubscriptionT {
//   channel: ChannelT,
//   connected: Function,
//   disconnected: Function,
//   received: Function,
//   onConnect: Function,
//   onDisconnect: Function,
//   onReceive: Function,
// }

interface ConsumerT {

}

export type {
  ChannelT,
  ConnectionT,
  MsgMeta,
  // SubscriptionT,
  SubscriptionCallbacksT,
  ConsumerT
}