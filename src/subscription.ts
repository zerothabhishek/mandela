import { ChannelT, MsgMeta, SubscriptionCallbacksT } from './d';

class Subscription {
  channel: ChannelT;
  connected: Function;
  disconnected: Function;
  received: Function;

  constructor (channel: ChannelT, callbacks: SubscriptionCallbacksT) {
    this.channel  = channel
    this.connected = callbacks.connected
    this.disconnected = callbacks.disconnected
    this.received = callbacks.received
  }

  onConnect(msg: object, meta: MsgMeta, socket: any) {
    this.connected(msg, meta, socket)
  }

  onReceive(msg: object, meta: MsgMeta, socket: any) {
    this.received(msg, meta, socket)
  }

  onDisconnect(msg: object, meta: MsgMeta, socket: any) {
    this.disconnected(msg, meta, socket)
  }
}

export default Subscription
